//
//  ReadViewScrollControllerInitView.swift
//  reader
//
//  Created by JiuHua on 2019/10/21.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

extension ReadViewScrollController: ReadMenuDelegate{
    
    func initContentView(){
        // 阅读使用范围
        let readRect = DZM_READ_RECT!
        
        // 顶部状态栏
        topView = ReadingViewTopView()
        topView.bookName.text = "书名"
        topView.chapterName.text = "章节名称"
        view.addSubview(topView)
        topView.frame = CGRect(x: readRect.minX, y: readRect.minY, width: readRect.width, height: topViewHeight)
        
        // 阅读视图
        tableView = ReadTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        view.addSubview(tableView)
        tableView.frame = CGRect(x: readRect.minX, y: readRect.minY + topView.frame.height + 10, width: readRect.width, height: readRect.height - topViewHeight - bottomViewHeight)
        
        //上刷新相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        footer.setTitle("上拉加载下一章", for: .idle)
        
        self.tableView!.mj_footer = footer
    }
    
    /// 添加单机手势
    func initTapGestureRecognizer() {
        // 单击手势
        singleTap = UITapGestureRecognizer(target: self, action: #selector(touchSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        self.tableView.addGestureRecognizer(singleTap)
    }
    
    /// 手势拦截
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    // 触发单击手势
    @objc private func touchSingleTap() {
        isMenuShow = !isMenuShow
        
        showMenuTopView(isShow: isMenuShow)
        
        showMenuBottomView(isShow: isMenuShow)
    }
    
    /// menuTopView展示
    func showMenuTopView(isShow:Bool, completion:AnimationCompletion? = nil) {
        if isShow { menuTopView.isHidden = false }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            let y = isShow ? 0 : -NavgationBarHeight
            self?.menuTopView.frame.origin = CGPoint(x: 0, y: y)
        }) { [weak self] (isOK) in
            if !isShow { self?.menuTopView.isHidden = true }
            completion?()
        }
    }
    
    /// menuBottomView展示
    func showMenuBottomView(isShow:Bool, completion:AnimationCompletion? = nil) {
        
        if isShow { menuBottomView.isHidden = false }
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] () in
            
            let y = isShow ? (screenHeight - bottomHeight) : screenHeight
            
            self?.menuBottomView.frame.origin = CGPoint(x: 0, y: y + 50)
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.menuBottomView.isHidden = true }
            
            completion?()
        }
    }
    
    
    /// 初始化MenuTopView
    func initMenuTopView() {
        
        menuTopView = ReadingMenuTopView()
        
        menuTopView.delegate = self
        
        menuTopView.isHidden = !isMenuShow
        
        self.view.addSubview(menuTopView)
        
        let y = isMenuShow ? 0 : -NavgationBarHeight
        
        menuTopView.frame = CGRect(x: 0, y: y, width: screenWidth, height: NavgationBarHeight)
    }
    
    /// 初始化MenuBottomView
    func initMenuBottomView() {
        
        menuBottomView = ReadingMenuBottomView()
        
        menuBottomView.isHidden = !isMenuShow
        
        menuBottomView.delegate = self
        
        self.view.addSubview(menuBottomView)
        
        let y = isMenuShow ? (screenHeight - bottomHeight) : screenHeight
        
        menuBottomView.frame = CGRect(x: 0, y: y, width: screenWidth, height: screenHeight)
        
        let path:CGMutablePath = CGMutablePath()
        
        let height = 55 * (screenWidth / 375)
        
        path.move(to: CGPoint(x: 0, y: height))
        
        path.addLine(to: CGPoint(x: menuBottomView.frame.width, y: height))
    
    }
    
}
