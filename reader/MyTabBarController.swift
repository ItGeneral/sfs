//
//  MyTabBarController.swift
//  reader
//
//  Created by JiuHua on 2019/10/1.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import SwiftyJSON
import CLToast

class MyTabBarController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkVersion()
        
    }
    
    func initTabBar() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .red
        
        let barTitleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)]
        
        // 设置tabBarItem选中与未选中的文字颜色
        let bookShelfNav = NavController(rootViewController: BookShelfViewController())
        let bookShelfBarItem = UITabBarItem(title: "书架", image: UIImage.init(named: "book_shelf"), selectedImage: UIImage.init(named: "book_shelf"))
        bookShelfBarItem.setTitleTextAttributes(barTitleAttribute, for: .normal)
        
        let bookMallNav = NavController(rootViewController: BookMallViewController())
        let bookMallTabBarItem = UITabBarItem(title: "书城", image: UIImage.init(named: "book_mall")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "book_mall"))
        bookMallTabBarItem.setTitleTextAttributes(barTitleAttribute, for: .normal)
        
        let userNav = NavController(rootViewController: UserViewController())
        let userTabBarItem = UITabBarItem(title: "我的", image: UIImage.init(named: "mine")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "mine"))
        userTabBarItem.setTitleTextAttributes(barTitleAttribute, for: .normal)
        
        
        bookShelfNav.tabBarItem = bookShelfBarItem
        bookMallNav.tabBarItem = bookMallTabBarItem
        userNav.tabBarItem = userTabBarItem
        self.viewControllers = [bookShelfNav, bookMallNav, userNav]
        
    }
    
    //跳转app store
    func initAlertController() {
        let alertController = UIAlertController(title: "系统提示", message: "请前往App Store下载最新版本", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            print("点击了确定")
            let str = NSString(format: "https://itunes.apple.com/us/app/pages/id361309726?mt=8&uo=4")
            
            UIApplication.shared.canOpenURL(NSURL(string: str as String)! as URL)
            
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func checkVersion(){
        let url = "cloud/api/version/check"
        AlamofireHelper.shareInstance.getRequest(url: url, params: ["version": "1"], completion: {(result, error) in
            let json = JSON(result as Any)
            let data = json["data"].dictionary
            let code = json["errorCode"].type == SwiftyJSON.Type.null ? 500 : json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            let version = data!["version"]?.int!
            if version != 1 {
                self.initAlertController()
            }else {
                self.initTabBar()
            }
            
        })
    }
    

}
