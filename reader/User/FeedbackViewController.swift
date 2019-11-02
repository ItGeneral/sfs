//
//  FeedbackViewController.swift
//  reader
//
//  Created by JiuHua on 2019/11/2.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import CLToast
import SwiftyJSON

class FeedbackViewController: UIViewController {
    
    var contentText = UITextField.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .white

        setNavigationBar()
        
        initFeedbaclUI()
        
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
    
    
    func initFeedbaclUI() {
        
        //判断是否登陆
        let account = ReadUserDefaults.object("ACCOUNT_INFO") as? UserInfoModel
        
        if account == nil {
            
            CLToast.cl_show(msg: "先登陆才能进行反馈")
            
            let controller = LoginViewController()
            
            self.navigationController?.pushViewController(controller, animated: false)
            
            return 
        }
        
        
        let titleLabel = UILabel.init()

        titleLabel.text = "请描述具体问题"
        
        self.view.addSubview(titleLabel)
        
        titleLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(NavgationBarHeight + 30 )
            make?.left.mas_equalTo()(10)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        contentText.placeholder = "请填写问题描述以便我们提供更好的帮助"
        
        contentText.borderStyle = .roundedRect
        
        contentText.keyboardType = .default
        
        contentText.adjustsFontSizeToFitWidth = true
        
        contentText.autocapitalizationType = .none
        
        self.view.addSubview(contentText)
        
        contentText.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(titleLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(150)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        let submitButton = UIButton.init()
        
        submitButton.setTitle("提  交", for: .normal)
        
        submitButton.backgroundColor = .colorButtonBlue()
        
        self.view.addSubview(submitButton)
        
        submitButton.mas_makeConstraints {(make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(20)
            make?.top.mas_equalTo()(contentText.mas_bottom)?.offset()(50)
            make?.width.mas_equalTo()(screenWidth - 20)
            make?.height.mas_equalTo()(40)
            make?.right.mas_equalTo()(-20)
        }
        
        submitButton.addTarget(self, action: #selector(submitFeedback), for: .touchDown)
        
        submitButton.layer.cornerRadius = 15
        
    }
    
    @objc func submitFeedback(){
        if contentText.text == ""{
            CLToast.cl_show(msg: "请输入具体问题")
            return
        }
        let account = ReadUserDefaults.object("ACCOUNT_INFO") as? UserInfoModel
        let url = "/cloud/api/feedback/submit"
        let params:[String:Any] = ["accountId": account!.id,"accountName": account!.accountName, "content": contentText.text!]
        AlamofireHelper.shareInstance.postRequest(url: url, params: params, completion: {(result, error) in
            let json = JSON(result as Any)
            let errorCode = json["errorCode"].int!
            let message = json["message"].string!
            if errorCode == 200{
                CLToast.cl_show(msg: "提交成功")
                //去用户页面
                let controller = UserViewController()
                
                self.navigationController?.pushViewController(controller, animated: false)
            }else{
                CLToast.cl_show(msg: message)
            }
        })
    }


}
