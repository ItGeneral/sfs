//
//  SettingViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/31.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class SettingViewController: UIViewController {
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .backgroundColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = .white
        
        self.tabBarController?.tabBar.isHidden = true
        
        setNavigationBar()
        
        initSettingView()
        
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
    
    func initSettingView(){
        let quitView = UIView.init()
        
        quitView.backgroundColor = .white
        
        self.view.addSubview(quitView)
        
        quitView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(self.view.mas_safeAreaLayoutGuideTop)
            make.height.mas_equalTo()(50)
            make.width.mas_equalTo()(screenWidth)
        }
        
        let quitLabel = UILabel.init()
        
        quitLabel.text = "退出登陆"
        
        quitLabel.isUserInteractionEnabled = true
        
        quitLabel.font = UIFont.systemFont(ofSize: 20)
        
        quitLabel.textColor = .colorBlue()
        
        quitLabel.textAlignment = .center
        
        quitView.addSubview(quitLabel)
        
        quitLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.center.mas_equalTo()(quitView)
            make.width.mas_equalTo()(screenWidth)
            make.height.mas_equalTo()(quitView.mas_height)
        }
        
        let quitTap = UITapGestureRecognizer.init(target: self, action: #selector(quitConfirm))
        
        quitLabel.addGestureRecognizer(quitTap)
        
        
        
    }
    
    
    @objc func quitConfirm() {
        //添加一个弹窗
        let controller = UIAlertController(title: "提示", message: "确定退出登陆吗？", preferredStyle: .alert)
        let confirmController = UIAlertAction(title: "确定", style: .default){
            (action) in
            ReadUserDefaults.remove("ACCOUNT_INFO")
            
            ReadUserDefaults.remove("ACCOUNT_ID")
            
            self.backToPrevious()
        }
        //取消退出
        let canceController = UIAlertAction(title: "取消", style: .default, handler: nil)
        //将确定和取消按钮添加到弹窗控制器
        controller.addAction(confirmController)
        controller.addAction(canceController)
        self.present(controller, animated: true, completion: nil)
    }
    
    
}
