//
//  MyReadingViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/31.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import SwiftyJSON
import CLToast
import MJRefresh

class MyReadingViewController: UITableViewController {

    var readHisttoryList = [ReadHistoryModel]()
    
    var pageNo:Int = 1
    
    var pageSize:Int = 10
    
    var total:Int = 0
    
    //分页刷新
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setNavigationBar()
        
        initTableView()
        
        initBookData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.barTintColor = .white
        
        self.tabBarController?.tabBar.isHidden = true
        
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
    
    func initTableView(){
        self.tableView.dataSource = self
        
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.isScrollEnabled = true
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReadHistoryCell")
        
        
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        
        header.stateLabel.isHidden = true
        
        self.tableView!.mj_header = header
        
        //上刷新相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        
        footer.setTitle("上拉加载更多数", for: .idle)
        
        self.tableView!.mj_footer = footer
        
    }
    
    //顶部下拉刷新
    @objc func headerRefresh(){
        header.setTitle("加载中", for: .refreshing)
        self.pageNo = 1
        self.readHisttoryList.removeAll()
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
        if self.total == self.readHisttoryList.count {
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

}

extension MyReadingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.readHisttoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ReadHistoryCell(style: UITableViewCell.CellStyle.default, reuseIdentifier:"ReadHistoryCell")
        
        let historyModel = readHisttoryList[indexPath.row]
        
        cell.drawCellView(historyModel: historyModel)
        
        //设置选中样式
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyModel = readHisttoryList[indexPath.row]
        
        let controller = ReadViewScrollController()
        controller.bookId = historyModel.bookId
        controller.chapterId = historyModel.bookChapterId
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func initBookData() {
        let url = "cloud/api/book/history/list"
        let accountId = ReadUserDefaults.integer("ACCOUNT_ID")
        let deviceUniqueId = ReaderUtil.getDeviceUUID()
        let param:[String : Any] = ["accountId": accountId, "deviceUniqueId":deviceUniqueId, "pageNo": pageNo, "pageSize": pageSize]
        AlamofireHelper.shareInstance.postRequest(url: url, params: param, completion: {(result, error) in
            let json = JSON(result as Any)
            let data = JSON(json["data"])
            let code = json["errorCode"].type == SwiftyJSON.Type.null ? 500 : json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            self.total = data["total"].int!
            let list = data["list"].array
            for index in list!{
                let historyModel = ReadHistoryModel()
                historyModel.bookId = index["bookId"].int!
                historyModel.bookName = index["bookName"].string!
                historyModel.author = index["author"].string!
                historyModel.coverUrl = index["coverUrl"].string!
                historyModel.updateTime = index["updateTimeStr"].string!
                historyModel.bookChapterId = index["bookChapterId"].int!
                self.readHisttoryList.append(historyModel)
            }
            self.tableView?.reloadData()
            if self.total ==  self.readHisttoryList.count {
                self.footer.setTitle("暂无更多数据", for: .idle)
            }
            
        })
    }
    
}
