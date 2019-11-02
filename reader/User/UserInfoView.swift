//
//  UserInfoView.swift
//  reader
//
//  Created by JiuHua on 2019/10/30.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class UserInfoView: UIView {

    static var leadingLabel:UILabel = UILabel.init()
    
    /// 登陆后显示用户信息view
    static func setUserLoginedHeadView(userInfo: UserInfoModel) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 120))
        var headUrl:String = "user_default"
        if userInfo.headUrl != ""  {
            headUrl = userInfo.headUrl
        }
        let headImage = UIImage.init(named: headUrl)
        let imageView = UIImageView.init()
        view.addSubview(imageView)
        imageView.image = headImage
        imageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.equalTo()(40)
            make?.width.height().equalTo()(80)
            make?.top.equalTo()(20)
        }
        
        let accountNameLabel = UILabel.init()
        accountNameLabel.text = userInfo.accountName
        accountNameLabel.textColor = UIColor(r: 102, g: 102, b: 102)
        accountNameLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        accountNameLabel.backgroundColor = .white
        view.addSubview(accountNameLabel)
        accountNameLabel.mas_makeConstraints {(make: MASConstraintMaker?) in
            make?.left.equalTo()(imageView.mas_right)?.offset()(20)
            make?.top.equalTo()(40)
        }
        
        let accountPhoneLabel = UILabel.init()
        accountPhoneLabel.text = userInfo.phone
        accountPhoneLabel.font = UIFont.boldSystemFont(ofSize: 16)
        accountPhoneLabel.textColor = .color113()
        view.addSubview(accountPhoneLabel)
        accountPhoneLabel.mas_makeConstraints{(make: MASConstraintMaker?) in
            make?.top.equalTo()(accountNameLabel.mas_bottom)?.offset()(10)
            make?.left.equalTo()(imageView.mas_right)?.offset()(20)
        }
        
        
        
        return view
    }
    
    //未登陆的head view
    static func setUserNotLoginHeadView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 120))
        let headImage = UIImage.init(named: "user_default")
        let imageView = UIImageView.init()
        view.addSubview(imageView)
        imageView.image = headImage
        imageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.equalTo()(40)
            make?.width.height().equalTo()(80)
            make?.top.equalTo()(20)
        }
        
        let accountPhoneLabel = UILabel.init()
        accountPhoneLabel.text = "登陆/注册"
        accountPhoneLabel.font = UIFont.boldSystemFont(ofSize: 20)
        accountPhoneLabel.textColor = .color113()
        view.addSubview(accountPhoneLabel)
        accountPhoneLabel.mas_makeConstraints{(make: MASConstraintMaker?) in
            make?.left.equalTo()(imageView.mas_right)?.offset()(20)
            make?.centerY.equalTo()(imageView)
        }
        
        let iconImage = UIImage.init(named: "setting_rightarrow")
        let iconImageView = UIImageView.init()
        iconImageView.image = iconImage
        view.addSubview(iconImageView)
        iconImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.right.equalTo()(-40)
            make?.centerY.mas_equalTo()(imageView)
            make?.height.mas_equalTo()(16)
            make?.width.mas_equalTo()(8)
        }
        return view
    }

}
