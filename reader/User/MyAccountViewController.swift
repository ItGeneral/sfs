//
//  MyAccountViewController.swift
//  reader
//
//  Created by JiuHua on 2019/11/2.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry


class MyAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        initView()
        
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

    
    func initView(){
        
        let label = UILabel.init()
        
        label.text = "暂无数据"
        
        label.textColor = .color230()
        
        self.view.addSubview(label)
        
        label.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.center.mas_equalTo()(self.view)
        }
        
        
        
    }

}
