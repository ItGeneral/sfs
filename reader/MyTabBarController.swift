//
//  MyTabBarController.swift
//  reader
//
//  Created by JiuHua on 2019/10/1.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    class func initTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.tabBar.tintColor = UIColor.red
        
        let bookShelfNav = NavController(rootViewController: BookShelfViewController())
        let bookShelfBarItem = UITabBarItem(title: "书架", image: UIImage.init(named: "stock"), selectedImage: nil)
        
        
        let bookMallNav = NavController(rootViewController: BookMallViewController())
        let bookMallTabBarItem = UITabBarItem(title: "书城", image: UIImage.init(named: "stock"), selectedImage: nil)
        
        
        let userNav = NavController(rootViewController: UserViewController())
        let userTabBarItem = UITabBarItem(title: "我的", image: UIImage.init(named: "stock"), selectedImage: nil)
        
        
        let barTitleAttribute : NSDictionary = NSDictionary(objects: [UIFont.systemFont(ofSize: 14.0)], forKeys: [NSAttributedString.Key.font as NSCopying])
        bookMallTabBarItem.setTitleTextAttributes(barTitleAttribute as? [NSAttributedString.Key : Any], for: .normal)
        userTabBarItem.setTitleTextAttributes(barTitleAttribute as? [NSAttributedString.Key : Any], for: .normal)
        bookShelfBarItem.setTitleTextAttributes(barTitleAttribute as? [NSAttributedString.Key : Any], for: .normal)
        
        bookShelfNav.tabBarItem = bookShelfBarItem
        bookMallNav.tabBarItem = bookMallTabBarItem
        userNav.tabBarItem = userTabBarItem
        tabBar.viewControllers = [bookMallNav, bookShelfNav, userNav]
        
        return tabBar
    }


}
