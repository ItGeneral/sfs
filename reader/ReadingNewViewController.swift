//
//  ReadingNewViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/18.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class ReadingNewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension ReadingNewViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    //上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    //下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    
}
