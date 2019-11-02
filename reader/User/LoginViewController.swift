//
//  LoginViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/30.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SwiftyJSON
import CLToast

class LoginViewController: UIViewController {

    /// 标题view
    var titleView: UIView!
    
    /// 用户名
    var accountNameTextfield:UITextField!
    
    /// 密码
    var passwordTextField:UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initLoginView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    func initLoginView(){
        
        titleView = UIView.init()
        
        self.view.addSubview(titleView)
        
        titleView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.width.mas_equalTo()(screenWidth)
            make.height.mas_equalTo()(50)
            make.top.mas_equalTo()(self.view.mas_safeAreaLayoutGuideTop)
        }
        
        ///标题名称
        let titleLabel = UILabel.init()
        
        titleLabel.text = "用户登录"
        
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        
        titleView.addSubview(titleLabel)
        
        titleLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.center.mas_equalTo()(titleView)
            make.height.mas_equalTo()(titleView.mas_height)
        }
        
        
        ///关闭按钮
        let closeButton = UIButton.init()
        
        closeButton.setImage(UIImage.init(named: "close"), for: .normal)
        
        closeButton.addTarget(self, action: #selector(closeLoginController), for: .touchUpInside)
        
        titleView.addSubview(closeButton)
        
        closeButton.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(0)
            make.width.height()?.mas_equalTo()(48)
            make.right.mas_equalTo()(-20)
        }
        
        
        let textFieldWidth = screenWidth - 40
        
        accountNameTextfield = UITextField.init()
        
        accountNameTextfield.placeholder = "用户名"
        
        accountNameTextfield.clearButtonMode = UITextField.ViewMode.whileEditing
        
        accountNameTextfield.keyboardType = .default
        
        accountNameTextfield.returnKeyType = .done
        
        accountNameTextfield.font = UIFont.systemFont(ofSize: 20)
        
        //首字母不大写
        accountNameTextfield.autocapitalizationType = .none
        
        self.view.addSubview(accountNameTextfield)
        
        accountNameTextfield.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.width.mas_equalTo()(textFieldWidth)
            make.height.mas_equalTo()(50)
            make.left.mas_equalTo()(20)
            make.right.mas_equalTo()(-20)
            make.top.mas_equalTo()(180)
        }
        /// 添加下划线
        LineViewUtil.setBottomBorder(textField: accountNameTextfield, color: UIColor.backgroundColor())
        
        /// 密码
        passwordTextField = UITextField.init()
        
        passwordTextField.placeholder = "密码"
        
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        
        passwordTextField.keyboardType = .default
        
        passwordTextField.returnKeyType = .done
        
        passwordTextField.font = UIFont.systemFont(ofSize: 20)
        
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        
        passwordTextField.isSecureTextEntry = true
        
        self.view.addSubview(passwordTextField)
        
        passwordTextField.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.width.mas_equalTo()(textFieldWidth)
            make.height.mas_equalTo()(50)
            make.left.mas_equalTo()(20)
            make.right.mas_equalTo()(-20)
            make.top.mas_equalTo()(accountNameTextfield.mas_bottom)?.offset()(20)
        }
        LineViewUtil.setBottomBorder(textField: passwordTextField, color: UIColor.backgroundColor())
        
        let registerLabel = UILabel.init()

        registerLabel.text = "注册账户"

        registerLabel.textColor = .colorBlue()

        registerLabel.isUserInteractionEnabled = true

        self.view.addSubview(registerLabel)

        registerLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(passwordTextField.mas_bottom)?.offset()(2)
            make.right.mas_equalTo()(-20)
            make.height.mas_equalTo()(50)
        }

        let registerTap = UITapGestureRecognizer.init(target: self, action: #selector(registerAccount))

        registerLabel.addGestureRecognizer(registerTap)
        
//        let forgetLabel = UILabel.init()
//
//        self.view.addSubview(forgetLabel)
//
//        forgetLabel.textColor = .colorBlue()
//
//        forgetLabel.text = "注册账户"
//
//        forgetLabel.isUserInteractionEnabled = true
//
//        forgetLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
//            make.top.mas_equalTo()(passwordTextField.mas_bottom)?.offset()(2)
//            make.right.mas_equalTo()(-20)
//            make.height.mas_equalTo()(50)
//        }
//
//        let forgetTap = UITapGestureRecognizer.init(target: self, action: #selector(forgetAccount))
//
//        forgetLabel.addGestureRecognizer(forgetTap)
        
        /// 登陆按钮
        let loginButton = UIButton.init()
        
        loginButton.setTitle("登  陆", for: .normal)
        
        loginButton.setTitleColor(.white, for: .normal)
        
        loginButton.backgroundColor = .colorButtonBlue()
        
        loginButton.layer.cornerRadius = 15
        
        self.view.addSubview(loginButton)
        
        loginButton.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.width.mas_equalTo()(textFieldWidth)
            make.top.mas_equalTo()(registerLabel.mas_bottom)?.offset()(20)
            make.height.mas_equalTo()(50)
            make.left.mas_equalTo()(20)
        }
        
        loginButton.addTarget(self, action: #selector(loginAccount), for: .touchUpInside)
        
    }
    
    /// 关闭页面
    @objc func closeLoginController() {
        
        let controller = UserViewController()
        
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    
    /// 注册账户
    @objc func registerAccount(){
        
        let controller = RegisterViewController()
        
        self.navigationController?.pushViewController(controller, animated: false)

    }
    
    /// 忘记密码
    @objc func forgetAccount(){
        print("forgetAccount")
    }
    
    
    /// 登陆账户
    @objc func loginAccount(){
        if !checkAccountAndPassword() {
            return
        }
        //调用登陆接口
        let url = "cloud/api/account/login"
        let params:[String:String] = ["accountName": accountNameTextfield.text!, "accountPassword": passwordTextField.text!]
        AlamofireHelper.shareInstance.postRequest(url: url, params: params, completion: {(result, error) in
            let json = JSON(result as Any)
            let errorCode = json["errorCode"].int!
            let message = json["message"].string!
            if errorCode == 200{
                CLToast.cl_show(msg: "登录成功")
                let userInfoModel = UserInfoModel()
                let data = JSON(json["data"])
                userInfoModel.accountName = data["accountName"].string!
                userInfoModel.phone = data["phone"].string!
                userInfoModel.id = data["id"].int!
                ReadUserDefaults.setObject(userInfoModel, "ACCOUNT_INFO")
                ReadUserDefaults.setInteger(userInfoModel.id, "ACCOUNT_ID")
                self.closeLoginController()
            }else{
                CLToast.cl_show(msg: message)
            }
        })
    }

    /// 校验用户名与密码
    func checkAccountAndPassword() -> Bool{
        let accountName = accountNameTextfield.text!
        if accountName == "" {
            CLToast.cl_show(msg: "用户名不能为空")
            return false
        }
        if accountName.count < 6 {
            CLToast.cl_show(msg: "用户名不得少于6位")
            return false
        }
        if accountName.count > 16 {
            CLToast.cl_show(msg: "用户名不得多于16位")
            return false
        }
        
        let accountNamePattern = "^[a-zA-Z][a-zA-Z0-9]+$"
        let accountNamePre = NSPredicate(format: "SELF MATCHES %@", accountNamePattern)
        if !accountNamePre.evaluate(with: accountName){
            CLToast.cl_show(msg: "用户名只能包含是数字和英文字母,且以字母开头")
            return false
        }
        
        let passwordPattern = "[a-zA-Z][a-zA-Z0-9._^%$#!~/&@-]+$"
        let passwordPre = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        let password = passwordTextField.text!
        if password == "" {
            CLToast.cl_show(msg: "密码不能为空")
            return false
        }
        if password.count < 8 || password.count > 16{
            CLToast.cl_show(msg: "密码长度必须大于8位小于16位")
            return false
        }
        if !passwordPre.evaluate(with: password){
            CLToast.cl_show(msg: "密码只能包含是数字,英文字母以及._^%$#!~/&@-，且以字母开头")
            return false
        }
        return true
    }
}
