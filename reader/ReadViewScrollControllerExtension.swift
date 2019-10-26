//
//  ReadViewScrollControllerExtension.swift
//  reader
//
//  Created by JiuHua on 2019/10/21.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import SwiftyJSON
import CLToast

extension ReadViewScrollController{
    
    /// 点击返回
    func backToPreviousController() {
        // 返回
        navigationController?.popViewController(animated: true)
    }
    
    //底部上拉加载
    @objc func footerLoad(){
        //生成并添加数据
        let count = self.bookChapterList.count
        let lastChapter = self.bookChapterList[count - 1]
        if lastChapter.nextId == 0{
            self.tableView!.mj_footer.endRefreshing()
            footer.setTitle("已是最后一章", for: .idle)
            return
        }
        
        self.chapterId = lastChapter.nextId
        
        self.getBookChapterData(isNext: true)
        //重现加载表格数据
        self.tableView!.reloadData()
        //结束刷新
        self.tableView!.mj_footer.endRefreshing()
    }
    
    /// 添加书架
    func addBookToShelf() {
        let url = "/cloud/api/book/shelf/save/"
        let accountId = ReadUserDefaults.integer("ACCOUNT_ID")
        let deviceUniqueId = ReaderUtil.getDeviceUUID()
        let param:[String : Any] = ["accountId": accountId, "deviceUniqueId":deviceUniqueId, "bookId": bookId, "bookChapterId": chapterId]
        AlamofireHelper.shareInstance.postRequest(url: url, params: param, completion: {(result, error) in
            let json = JSON(result as Any)
            let code = json["errorCode"].type == SwiftyJSON.Type.null ? 500 : json["errorCode"].int!
            if code == 200 {
                CLToast.cl_show(msg: "已加入书架")
                return
            }
        })
        
    }
    
    /// 获取上一章或下一章数据
    /// 点击下一章 如果数组中已经有了下一章节的内容，则直接跳到对应的章节，否则请求网络数据加载到数组中
    /// 点击上一章 如果数组中已经有了上一章节的内容，则直接跳到对应的章节，否则请求网络数据加载到数组中
    func loadNextOrPreviousChapter(isNext:Bool) {
        if isNext {
            self.chapterId +=  1
            
            if self.chapterIdList.contains(self.chapterId){
                
                let index = self.chapterIdList.firstIndex(of: self.chapterId)
                
                tableView.scrollToRow(at: IndexPath(row: index!, section: 0), at: .top, animated: false)
                
                return
            }
        }else{
            self.chapterId -=  1
            
            if self.chapterIdList.contains(self.chapterId){
                
                let index = self.chapterIdList.firstIndex(of: self.chapterId)
                
                tableView.scrollToRow(at: IndexPath(row: index!, section: 0), at: .top, animated: false)
                
                return
            }
        }
        getBookChapterData(isNext: isNext)
    }
    
    /// 加载网络数据
    func getBookChapterData(isNext: Bool) {
        if chapterModel.previousId == 0 {
            return
        }
        if chapterModel.nextId == 0 {
            return
        }
        
        let loadingView = LoadingView.initLoadingView(view: self.view)
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)
        
        let deviceUUID = ReaderUtil.getDeviceUUID()
        let accountId = ReadUserDefaults.integer("ACCOUNT_ID")
        let url = "/cloud/api/book/chapter/" + String(self.bookId) + "/" + String(self.chapterId)
        let param:[String : String] = ["deviceUniqueId": deviceUUID, "accountId": String(accountId)]
        AlamofireHelper.shareInstance.getRequest(url: url, params: param, completion: {(result, error) in
            let json = JSON(result as Any)
            let index = json["data"]
            let code = json["errorCode"].type == SwiftyJSON.Type.null ? 500 : json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            let bookChapter = BookChapterModel()
            bookChapter.content = index["content"].string!
            bookChapter.bookId = index["bookId"].int!
            bookChapter.volumeId = index["volumeId"].int!
            bookChapter.name = index["name"].string!
            bookChapter.id = index["id"].int!
            bookChapter.nextId = index["nextId"].int!
            bookChapter.previousId = index["previousId"].int!
            bookChapter.sortNo = index["sortNo"].int!
            bookChapter.content = "\t" + bookChapter.content.replacingOccurrences(of: "。 ", with: "。 \n\r\t")
            bookChapter.bookName = index["bookName"].string!
            bookChapter.heightSize = CGFloat.init(Float(bookChapter.content.length))
            
            self.bookChapterList.append(bookChapter)
            self.chapterIdList.append(bookChapter.id)
            
            self.sortChapterData()
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                if isNext {
                    self.tableView.scrollToRow(at: IndexPath(row: self.chapterIdList.count - 1, section: 0), at: .top, animated: false)
                }else {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            })
            
            self.view.subviews.forEach({ (subView: UIView) in
                if subView is LoadingView{
                    subView.removeFromSuperview()
                }
            })
        })
    }
    
    func sortChapterData(){
        self.bookChapterList.sort(by: { (firstModel
            , secondModel) -> Bool in
            return (firstModel.id < secondModel.id)
        })
        self.chapterIdList.sort { (first
            , second) -> Bool in
            return first < second
        }
    }
    
    /// 点击目录
    func clickCatalogue() {
        
        loadBookDetail()
        
    }
    
    // 获取书详情
    func loadBookDetail() {
        let url = "cloud/api/book/detail/" + String(self.chapterModel.bookId)
        AlamofireHelper.shareInstance.postRequest(url: url, params: [:], completion: {(result, error) in
            let json = JSON(result as Any)
            let bookDetail = JSON(json["data"])
            let code = json["errorCode"].type == SwiftyJSON.Type.null ? 500 : json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            let chapterCount = bookDetail["chapterCount"].int!
           
            let controller = BookContentViewController()
            controller.initChapterList(chapterCount: chapterCount, bookId: self.chapterModel.bookId)
            self.navigationController?.pushViewController(controller, animated: false)
        })
    }
    
}

@objc protocol ReadMenuDelegate:NSObjectProtocol {

    @objc func loadNextOrPreviousChapter(isNext:Bool)
    
    @objc func addBookToShelf()
    
    @objc func backToPreviousController()
    
    @objc func clickCatalogue()

}
