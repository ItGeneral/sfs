//
//  BookListViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/4.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SwiftyJSON
import CLToast
import MJRefresh

class BookListViewController: UIViewController {

    var tableView:UITableView!
    //类型
    var bookType:String = ""
    
    var scrollView:UIScrollView!
    
    var bookList = [BookInfoModel]()
    
    var pageNo:Int = 1
    var pageSize:Int = 10
    var total:Int = 0
    
    //分页刷新
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    func setBookType(bookType:String) {
        self.bookType = bookType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.setNavigationBar()
        
        self.scrollView = UIScrollView.init()
        self.scrollView?.delegate = self
        self.scrollView?.isScrollEnabled = true
        self.scrollView?.bounces = true
        self.view.addSubview(self.scrollView)
        self.scrollView.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.edges.mas_equalTo()(self.view)
        }
        
        self.tableView = UITableView.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookListTableViewCell")
        self.scrollView.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(0)
            make?.right.mas_equalTo()(-10)
            make?.top.mas_equalTo()(20)
            make?.width.mas_equalTo()(screenWidth - 10)
            make?.height.mas_equalTo()(screenHeight - 120)
        }
        self.initBookData()
        
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(BookListViewController.headerRefresh))
        header.stateLabel.isHidden = true
        self.tableView!.mj_header = header
        
        //上刷新相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(BookListViewController.footerLoad))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        footer.setTitle("上拉加载更多数", for: .idle)
        
        self.tableView!.mj_footer = footer
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        header.setTitle("加载中", for: .refreshing)
        self.pageNo = 1
        self.bookList.removeAll()
        self.initBookData()
        //重现加载表格数据
        self.tableView!.reloadData()
        //结束刷新
        self.tableView!.mj_header.endRefreshing()
        footer.setTitle("上拉加载更多数", for: .idle)
    }
    
    //底部上拉加载
    @objc func footerLoad(){
        //生成并添加数据
        self.pageNo += 1
        if self.total == self.bookList.count {
            self.tableView!.mj_footer.endRefreshing()
            footer.setTitle("暂无更多数据", for: .idle)
            return
        }
        self.initBookData()
        //重现加载表格数据
        self.tableView!.reloadData()
        //结束刷新
        self.tableView!.mj_footer.endRefreshing()
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
    
}
extension BookListViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BookListTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier:"BookListTableViewCell")
        let bookInfo = self.bookList[indexPath.row]
        cell.drawCellView(bookInfo: bookInfo)
        //设置选中样式
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookInfo = self.bookList[indexPath.row]
        let controller = BookDetailViewController()
        controller.setBookDetail(bookDetail: bookInfo)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func initBookData() {
        let url = "cloud/api/book/list"
        let param:[String:Any] = ["type": self.bookType, "pageNo": pageNo, "pageSize": pageSize]
        AlamofireHelper.shareInstance.postRequest(url: url, params: param, completion: {(result, error) in
            let json = JSON(result as Any)
            let data = JSON(json["data"])
            let code = json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            self.total = data["total"].int!
            let list = data["list"].array
            for index in list!{
                let book = BookInfoModel()
                book.id = index["id"].int!
                book.name = index["name"].string!
                book.author = index["author"].string!
                book.coverUrl = index["coverUrl"].string!
                book.introduce = index["introduce"].string!
                book.type = index["type"].string!
                book.tag = index["tag"].string!
                book.wordNumber = index["wordNumber"].int!
                self.bookList.append(book)
            }
            self.tableView?.reloadData()
            if self.total ==  self.bookList.count {
                self.footer.setTitle("暂无更多数据", for: .idle)
            }
        })
    }
}
