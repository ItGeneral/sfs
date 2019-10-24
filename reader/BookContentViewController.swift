//
//  BookContentViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/15.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SwiftyJSON
import CLToast

struct ChapterContent {
    var content:String!
    var startNo:Int!
    var endNo:Int!
}

class BookContentViewController: UIViewController {

    var tableView:UITableView!
    
    var pickerView: UIPickerView!
    
    var confirmView: UIView!
    
    var selectedChapterItemLable: UILabel!
    
    var iconImageView: UIImageView!
    
    var headerView:UIView!
    //下拉框数据
    var chapterList = [ChapterContent]()
    //章节总数
    var chapterCount:Int!
    //章节列表
    var chapterModelList = [BookChapterModel]()
    //书ID
    var bookId:Int!
    //开始章节
    var startNo:Int!
    //结束章节
    var endNo:Int!
    
    var maskLayer = CALayer()
    //初始化章节选择下拉列表
    func initChapterList(chapterCount: Int, bookId:Int) {
        self.bookId = bookId
        self.chapterCount = chapterCount
        var chapterContent = ChapterContent()
        if self.chapterCount <= 50 {
            chapterContent.startNo = 1
            chapterContent.endNo = self.chapterCount
            chapterContent.content = "1-" + String(self.chapterCount) + "章"
            self.chapterList.append(chapterContent)
        }else{
            let size = self.chapterCount / 50
            for i in 0...size - 1{
                chapterContent.startNo = i * 50 + 1
                chapterContent.endNo = (i + 1) * 50
                chapterContent.content = String(i * 50 + 1) + "-" + String((i + 1) * 50) + "章"
                self.chapterList.append(chapterContent)
            }
            chapterContent.startNo = size * 50 + 1
            chapterContent.endNo = self.chapterCount
            chapterContent.content = String((size) * 50 + 1) + "-" + String(self.chapterCount) + "章"
            self.chapterList.append(chapterContent)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor()
        self.initPickerView()
        self.initHeader()
        self.initTableView()
        self.initChapterFromDB(startNo: 1, endNo: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.navigationController?.navigationBar.barTintColor = .none
        self.navigationController?.navigationBar.isHidden = false
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
    
    //初始化第一行
    func initHeader(){
        headerView = UIView.init()
        headerView.backgroundColor = .white
        self.view.addSubview(headerView)
        headerView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(85)
            make.width.mas_equalTo()(screenWidth)
            make.height.mas_equalTo()(50)
        }
        
        let chapterCountLabel = UILabel.init()
        chapterCountLabel.text = "共" + String(self.chapterCount) + "章"
        headerView.addSubview(chapterCountLabel)
        chapterCountLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(20)
            make.height.mas_equalTo()(29)
            make.left.mas_equalTo()(15)
        }
        
        iconImageView = UIImageView.init()
        iconImageView.image = UIImage.init(named: "icon_mr")
        headerView.addSubview(iconImageView)
        iconImageView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.center.mas_equalTo()(chapterCountLabel)
            make.right.mas_equalTo()(-10)
            make.height.mas_equalTo()(49)
            make.width.mas_equalTo()(10)
            make.height.mas_equalTo()(10)
        }
        
        self.selectedChapterItemLable = UILabel.init()
        self.selectedChapterItemLable.text = self.chapterList[0].content
        self.selectedChapterItemLable.isUserInteractionEnabled = true
        headerView.addSubview(self.selectedChapterItemLable)
        self.selectedChapterItemLable.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(20)
            make.right.mas_equalTo()(iconImageView.mas_left)?.offset()(-10)
            make.height.mas_equalTo()(29)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showConfirmView))
        self.selectedChapterItemLable.addGestureRecognizer(tap)
        
        let bottomLine = UIView.init()
        bottomLine.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        headerView.addSubview(bottomLine)
        bottomLine.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(10)
            make?.right.mas_equalTo()(-10)
            make?.width.mas_equalTo()(screenWidth - 20)
            make?.height.mas_equalTo()(1)
            make?.top.mas_equalTo()(chapterCountLabel.mas_bottom)?.offset()(0)
        }
    }
    
    func initTableView() {
        self.tableView = UITableView.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = true
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookContentCell")
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        self.view.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(headerView.mas_bottom)?.offset()(0)
            make?.bottom.mas_equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
            make?.width.mas_equalTo()(screenWidth)
            make?.height.mas_equalTo()(screenHeight - 140)
        }
    }
    
    
    func initPickerView() {
        self.confirmView = UIView.init()
        self.confirmView.isHidden = true
        self.view.addSubview(confirmView)
        confirmView.backgroundColor = .white
        confirmView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make?.bottom.mas_equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
            make.width.mas_equalTo()(screenWidth)
            make.height.mas_equalTo()(300)
        }
        
        let confirmLabel = UILabel.init()
        confirmLabel.text = "确定"
        confirmLabel.textColor = .colorBlue()
        confirmLabel.isUserInteractionEnabled = true
        self.confirmView.addSubview(confirmLabel)
        confirmLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.right.mas_equalTo()(-20)
            make.height.mas_equalTo()(48)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(confirmChapterItem))
        confirmLabel.addGestureRecognizer(tap)
        
        let lineView = UIView.init()
        lineView.backgroundColor = .backgroundColor()
        self.confirmView.addSubview(lineView)
        lineView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.height.mas_equalTo()(1)
            make.width.mas_equalTo()(screenWidth)
            make.top.mas_equalTo()(confirmLabel.mas_bottom)?.offset()(1)
        }
        
        self.pickerView = UIPickerView.init()
        self.pickerView.backgroundColor = .white
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.confirmView.addSubview(self.pickerView)
        self.pickerView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(lineView.mas_bottom)?.offset()(5)
            make?.width.mas_equalTo()(screenWidth)
            make?.height.mas_equalTo()(250)
        }
    }
    
    
    @objc func confirmChapterItem() {
        let checked = self.pickerView.selectedRow(inComponent: 0)
        let chapterContent = self.chapterList[checked]
        self.selectedChapterItemLable.text = chapterContent.content
        self.confirmView.isHidden = true
        self.iconImageView.image = UIImage.init(named: "icon_mr")
        self.initChapterFromDB(startNo: chapterContent.startNo, endNo: chapterContent.endNo)
    }
    

}

extension BookContentViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chapterModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookContentCell")
        cell?.textLabel?.text = self.chapterModelList[indexPath.row].name
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.confirmView.isHidden {
            let chapterModel = self.chapterModelList[indexPath.row]
            
            let controller = ReadViewScrollController()
            controller.bookId = self.bookId
            controller.chapterId = chapterModel.id
            
            self.navigationController?.pushViewController(controller, animated: false)
        }else{
            self.confirmView.isHidden = true
        }
    }

    //选择框弹层
    @objc func showConfirmView() {
        self.confirmView.isHidden = false
        self.view.bringSubviewToFront(self.confirmView)
        iconImageView.image = UIImage.init(named: "icon_xl")
    }
    
    func initChapterFromDB(startNo:Int, endNo:Int) {
        if self.startNo == startNo {
            return
        }
        
        let loadingView = LoadingView.initLoadingView(view: self.view)
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)

        
        self.startNo = startNo
        self.endNo = endNo
        self.chapterModelList = []
        self.tableView.separatorStyle = .none
        self.tableView?.reloadData()
        let url = "cloud/api/book/chapter/content"
        let param:[String:Any] = ["bookId": self.bookId!, "startNo": startNo, "endNo": endNo]
        AlamofireHelper.shareInstance.postRequest(url: url, params: param, completion: {(result, error) in
            let json = JSON(result as Any)
            let list = json["data"].array!
            let code = json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            for index in list{
                let bookChapter = BookChapterModel()
                bookChapter.id = index["id"].int!
                bookChapter.name = index["name"].string!
                bookChapter.content = index["content"].string!
                self.chapterModelList.append(bookChapter)
            }
            self.view.subviews.forEach({ (subView: UIView) in
                if subView is LoadingView{
                    subView.removeFromSuperview()
                }
            })
            self.tableView?.reloadData()
            self.tableView.separatorStyle = .singleLine
        })
    }

}

extension BookContentViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.chapterList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    //设置没项数据的值
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.chapterList[row].content
    }
    
}
