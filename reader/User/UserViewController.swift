//
//  UserViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/1.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {

    //用户中心
    var myCells = [UserCellModel]()
    
    var userInfo: UserInfoModel = UserInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.isScrollEnabled = false
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserInfoCell")
        
        myCells.append(UserCellModel.initUserCell(cellName: "我的账户", cellIcon: "my_account"))
        myCells.append(UserCellModel.initUserCell(cellName: "我的阅读", cellIcon: "my_book_list"))
        myCells.append(UserCellModel.initUserCell(cellName: "帮助与反馈", cellIcon: "my_feedback"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        checkLoginAndInitHeaderView()
        
    }
    
    /// 初始化头像
    func checkLoginAndInitHeaderView() {
        var headView = UIView.init()
        let account = ReadUserDefaults.object("ACCOUNT_INFO") as? UserInfoModel
        if account == nil || account!.accountName == ""{
            myCells.removeAll { (cell : UserCellModel) -> Bool in
                if cell.cellName == "设置" {
                    return true
                }
                return false
            }
            
            //未登陆
            headView = UserInfoView.setUserNotLoginHeadView()
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(goToLoginController))
            headView.addGestureRecognizer(tap)
        }else {
            //已登陆
            headView = UserInfoView.setUserLoginedHeadView(userInfo: account!)
            var existSetting = false
            for cell in myCells{
                if cell.cellName == "设置" {
                    existSetting = true
                    break
                }
            }
            if !existSetting{
                myCells.append(UserCellModel.initUserCell(cellName: "设置", cellIcon: "my_setting"))
            }
        }
        self.tableView.reloadData()
        self.tableView.tableHeaderView = headView
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    
}
extension UserViewController{
    // 每组头部的高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    // 每组头部视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = .color250()
        return view
    }
    // 行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // 每组的行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCells.count
    }
    // cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = myCells[indexPath.row]
        
        let cell = UserInfoCell(style: UITableViewCell.CellStyle.default, reuseIdentifier:"UserInfoCell", userCell: userCell, row: indexPath.row)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var controller = UIViewController()
        
        //设置
        if indexPath.row == 0 {
            
            controller = MyAccountViewController()
            
        }else if indexPath.row == 1 {
            
            controller = MyReadingViewController()
            
        }else if indexPath.row == 2 {
            
            controller = FeedbackViewController()
            
        }else if indexPath.row == 3 {
            
            controller = SettingViewController()
            
        }
        
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    
    @objc func goToLoginController(){
        let controller = LoginViewController()
        
        self.navigationController?.pushViewController(controller, animated: false)
        
        //self.present(controller, animated: false)
        
    }

    


}
