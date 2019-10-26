//
//  ReadingViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/2.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SwiftyJSON
import CLToast

class ReadingViewController: UIViewController {
    //图书ID
    var bookId:Int!
    //章节ID
    var chapterId:Int!
    //本章内容
    var bookChapter: BookChapterModel! = BookChapterModel()
    
    var textView: UITextView!
    var color = UIColor(red: 255/255.0, green: 235/255.0, blue: 207/255.0, alpha: 1)
    
    func setBookShelfModel(bookId: Int, chapterId: Int) {
        self.bookId = bookId
        self.chapterId = chapterId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = self.color
        self.navigationController?.topViewController?.title = self.bookChapter.name
        self.navigationController?.navigationBar.titleTextAttributes = .none
        self.setNavigationBar()
        self.initTextView()
        self.getBookChapterData()
        self.view.backgroundColor = .white
    }
    
    func initTextView() {
        self.textView = UITextView.init()
        self.textView.font = UIFont.boldSystemFont(ofSize: 20)
        self.textView.isEditable = false
        self.textView.backgroundColor = self.color
        self.textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0);
        self.view.addSubview(self.textView)
        self.textView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(screenHeight)
            make?.width.mas_equalTo()(screenWidth)
            //make?.top.mas_equalTo()(self.view.mas_safeAreaLayoutGuideTop)
            make?.bottom.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ReadingViewController.clickSliding(tt:)))
        self.textView.addGestureRecognizer(tap)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backToPrevious))
        item.image = UIImage.init(named: "lefterbackicon_titlebar_24x24_")
        self.navigationItem.leftBarButtonItem = item
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func clickSliding(tt: UITapGestureRecognizer ){
        let point = tt.location(in: self.textView)
        let currentY = point.y;
        var offset = self.textView.contentOffset
        if currentY > screenHeight/2 {
            offset.y += 200;
        }else{
            offset.y -= 200
        }
        if offset.y < 0 {
            offset.y = 0
        }
        if offset.y > (self.textView.contentSize.height - self.textView.frame.height) {
            offset.y = (self.textView.contentSize.height - self.textView.frame.height) + 50
        }
        self.textView.contentOffset = offset
    }
    
    func getBookChapterData() {
        let url = "/cloud/api/book/chapter/" + String(self.bookId) + "/" + String(self.chapterId)
        let param:[String : String] = [:]
        AlamofireHelper.shareInstance.getRequest(url: url, params: param, completion: {(result, error) in
            let json = JSON(result as Any)
            let index = json["data"]
            let code = json["errorCode"].type == SwiftyJSON.Type.null ? 500 : json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            self.bookChapter.content = index["content"].string!
            self.bookChapter.bookId = index["bookId"].int!
            self.bookChapter.volumeId = index["volumeId"].int!
            self.bookChapter.name = index["name"].string!
            self.bookChapter.id = index["id"].int!
            self.bookChapter.nextId = index["nextId"].int!
            self.bookChapter.previousId = index["previousId"].int!
            self.bookChapter.sortNo = index["sortNo"].int!
            self.textView.text = "\t" + self.bookChapter.content.replacingOccurrences(of: "。 ", with: "。 \n\r\t")
            self.showNextOrPreviousChapter()
            self.navigationController?.topViewController?.title = self.bookChapter.name
        })
    }
    
    func showNextOrPreviousChapter() {
        //上一章  目录   下一章
        let labelWidth = (self.textView.frame.width - 40)/3
        let previousLabel = UILabel.init()
        previousLabel.text = "上一章"
        previousLabel.textColor = .red
        previousLabel.textAlignment = .center
        previousLabel.font = UIFont.boldSystemFont(ofSize: 20)
        previousLabel.isUserInteractionEnabled = true
        self.textView.addSubview(previousLabel)
        previousLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(self.textView.contentSize.height - 20)
            make?.width.mas_equalTo()(labelWidth)
            make?.left.mas_equalTo()(10)
        }
        let previousTap = UITapGestureRecognizer.init(target: self, action: #selector(ReadingViewController.goToPreviousChapter))
        previousLabel.addGestureRecognizer(previousTap)
        
        let contentLable = UILabel.init()
        contentLable.text = "目 录"
        contentLable.textColor = .red
        contentLable.textAlignment = .center
        contentLable.isUserInteractionEnabled = true
        contentLable.font = UIFont.boldSystemFont(ofSize: 20)
        self.textView.addSubview(contentLable)
        contentLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(self.textView.contentSize.height - 20)
            make?.width.mas_equalTo()(labelWidth)
            make?.left.mas_equalTo()(previousLabel.mas_right)?.offset()(10)
        }
        let contentTap = UITapGestureRecognizer.init(target: self, action: #selector(ReadingViewController.goToContent))
        contentLable.addGestureRecognizer(contentTap)
        
        let nextLable = UILabel.init()
        nextLable.text = "下一章"
        nextLable.textColor = .red
        nextLable.textAlignment = .center
        nextLable.isUserInteractionEnabled = true
        nextLable.font = UIFont.boldSystemFont(ofSize: 20)
        self.textView.addSubview(nextLable)
        nextLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.width.mas_equalTo()(labelWidth)
            make?.left.mas_equalTo()(contentLable.mas_right)?.offset()(10)
            make?.top.mas_equalTo()(self.textView.contentSize.height - 20)
        }
        let nextTap = UITapGestureRecognizer.init(target: self, action: #selector(ReadingViewController.goToNextChapter))
        nextLable.addGestureRecognizer(nextTap)
        
    }
    
    @objc func goToPreviousChapter() {
        print("previous")
        self.chapterId -= 1
        let controller = ReadingViewController()
        controller.setBookShelfModel(bookId: self.bookId, chapterId: self.chapterId)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @objc func goToNextChapter() {
        self.chapterId += 1
        let controller = ReadingViewController()
        controller.setBookShelfModel(bookId: self.bookId, chapterId: self.chapterId)
        self.navigationController?.pushViewController(controller, animated: false)
        print("next")
    }
    
    @objc func goToContent()  {
        print("goToContent")
    }

}
