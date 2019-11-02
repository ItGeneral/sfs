//
//  NavController.swift
//  reader
//
//  Created by JiuHua on 2019/9/30.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(objects: [UIFont.systemFont(ofSize: 14.0), UIColor.red], forKeys: [NSAttributedString.Key.font as NSCopying, NSAttributedString.Key.foregroundColor as NSCopying])
        
        self.navigationBar.titleTextAttributes = navigationTitleAttribute as! [AnyHashable: Any] as? [NSAttributedString.Key : Any]
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 10)
        
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    


}
