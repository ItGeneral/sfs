//
//  BaseViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/25.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(r: 0.92, g: 0.92, b: 0.92, alpha: 1)
        
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

}
