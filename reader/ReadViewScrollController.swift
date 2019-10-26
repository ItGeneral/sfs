//
//  ReadViewScrollController.swift
//  reader
//
//  Created by JiuHua on 2019/10/19.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import SwiftyJSON
import CLToast
import Masonry
import MJRefresh

let bottomHeight = TabBarHeight + 55 * (screenWidth / 375)

class ReadViewScrollController: UIViewController {

    /// 图书ID
    var bookId:Int!
    
    /// 章节ID
    var chapterId:Int!
    
    /// 当前章节
    var chapterModel: BookChapterModel! = BookChapterModel()
    
    /// 章节列表
    var bookChapterList = [BookChapterModel]()
    
    /// 存储章节ID列表
    var chapterIdList = [Int]()
    
    /// 头部试图
    var topView:ReadingViewTopView!
    
    /// 记录滚动坐标
    private var scrollPoint:CGPoint!
    
    /// 阅读主视图
    var tableView:ReadTableView!
    
    /// 下拉加载数据
    let footer = MJRefreshAutoNormalFooter()
    
    /// 是否为向上滚动
    private var isScrollUp:Bool = true
    
    /// 头菜单
    var menuTopView: ReadingMenuTopView!
    
    /// 底部菜单
    var menuBottomView: ReadingMenuBottomView!
    
    /// 菜单显示状态
    var isMenuShow:Bool = false
    
    /// 单击手势
    var singleTap:UITapGestureRecognizer!
    
    /// 方法代理
    var delegate: ReadMenuDelegate!
    
    var locationChapter:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBookChapterData(isNext: true)
        
        view.backgroundColor = READ_COLOR_BG_0
        
        addSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addSubviews() {
        /// 初始化内容
        initContentView()
        
        // 初始化导航栏
        initMenuTopView()
        
        // 初始化菜单底部
        initMenuBottomView()
        
        // 添加单机手势
        initTapGestureRecognizer()
    }
    
    
    
    
}
extension ReadViewScrollController: UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookChapterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ReadViewCell.cell(tableView)
        
        cell.subviews.forEach { (subView: UIView) in
            subView.removeFromSuperview()
        }
        
        
        let chapterModel = bookChapterList[indexPath.row]
        self.setCellUI(chapterModel: chapterModel, cell: cell)
        
        topView.chapterName.text = chapterModel.name
        topView.bookName.text = chapterModel.bookName
                
        chapterId = chapterModel.id
        
        self.chapterModel = chapterModel
        
        //判断是否是第一章
        menuBottomView.currentChapterModel = chapterModel
        if chapterModel.previousId == 0 {
            menuBottomView.previousChapter.textColor = .color166()
        }else{
            menuBottomView.previousChapter.textColor = .color230()
        }
        if chapterModel.nextId == 0 {
            menuBottomView.nextChapter.textColor = .color166()
        }else{
            menuBottomView.nextChapter.textColor = .color230()
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chapterModel = bookChapterList[indexPath.row]
        return chapterModel.heightSize
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    func setCellUI(chapterModel: BookChapterModel, cell: ReadViewCell) {
        let chapterNameLabel = UILabel.init()
        chapterNameLabel.text = chapterModel.name
        chapterNameLabel.font = UIFont.systemFont(ofSize: 24)
        chapterNameLabel.textAlignment = .center
        cell.addSubview(chapterNameLabel)
        chapterNameLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(15)
            make.width.mas_equalTo()(DZM_READ_RECT.width)
        }
        
        let textLabel = UILabel.init()
        textLabel.text = chapterModel.content
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 20)
        cell.addSubview(textLabel)
        let textHeight = chapterModel.heightSize - 70
        textLabel.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.width.mas_equalTo()(DZM_READ_RECT.width)
            make.top.mas_equalTo()(chapterNameLabel.mas_bottom)?.offset()(10)
            make.height.mas_equalTo()(textHeight)
        }
        
        let lineWidth = DZM_READ_RECT.width/2 - 30
        let footView = UIView.init()
        cell.addSubview(footView)
        footView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(textLabel.mas_bottom)?.offset()(5)
            make.width.mas_equalTo()(DZM_READ_RECT.width)
            make.height.mas_equalTo()(30)
        }
        
        let leftView = LineViewUtil.init(frame: CGRect(x: 0, y: 0, width: lineWidth, height: 1))
        leftView.drawDashLine(strokeColor: UIColor.black)
        footView.addSubview(leftView)
        leftView.mas_updateConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(15)
        }
        
        let bottomLabel = UILabel.init()
        bottomLabel.text = "本章完"
        bottomLabel.textAlignment = .center
        footView.addSubview(bottomLabel)
        bottomLabel.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.top.mas_equalTo()(5)
            make.width.mas_equalTo()(60)
            make.left.mas_equalTo()(lineWidth)
        }
        
        let rightView = LineViewUtil.init(frame: CGRect(x: 0, y: lineWidth + 60, width: lineWidth, height: 1))
        rightView.drawDashLine(strokeColor: UIColor.black)
        footView.addSubview(rightView)
        rightView.mas_updateConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(15)
            make.left.mas_equalTo()(lineWidth + 60)
        }
    }
    
    
}

