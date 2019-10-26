//
//  BookSearchController.swift
//  reader
//
//  Created by JiuHua on 2019/10/24.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class BookSearchController: UIViewController {

    /// 搜索view
    var searchView: UIView!
    
    /// 内容view
    var contentView: UIView!
    
    var hotSearchList = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .backgroundColor()
        
        hotSearchList = ["大唐刁民", "诡局", "诸天主宰", "刑侦实录", "浮云圣尊", "剑凌太古", "终极进化", "一品帝师", "始皇诀之破灭长生", "银河之舟"]
        
        initSearchView()
        
        initContentView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /// 初始化initSearchView
    func initSearchView(){
        
        let searchBar = UISearchBar.init()
        
        searchBar.setBackgroundImage(UIColor.backgroundColor().trans2Image(), for: .any, barMetrics: .default)
        
        searchBar.placeholder = "搜索书城"
        
        searchBar.barTintColor = .white
        
        searchBar.showsCancelButton = false
        
        searchBar.delegate = self
        
        searchView = UIView.init()
        
        searchView.backgroundColor = .backgroundColor()
        
        searchView.addSubview(searchBar)
        searchBar.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(5)
            make.width.mas_equalTo()(screenWidth - 60)
            make.height.mas_equalTo()(50)
        }
        
        let cancelBtn = UIButton.init()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.colorBlue(), for: .normal)
        cancelBtn.addTarget(self, action: #selector(clickCancelButton), for: .touchDown)
        searchView.addSubview(cancelBtn)
        cancelBtn.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(7)
            make.height.mas_equalTo()(35)
            make.right.mas_equalTo()(-10)
        }

        self.view.addSubview(searchView)
        
        searchView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(self.view.mas_safeAreaLayoutGuideTop)
            make.width.mas_equalTo()(screenWidth)
            make.height.mas_equalTo()(50)
        }
        
    }
    
    
    /// 初始化内容页面
    func initContentView(){
        contentView = UIView.init()
        
        contentView.backgroundColor = .white
        
        self.view.addSubview(contentView)
        
        let contentHeight = screenHeight - searchView.frame.height - 10
        
        contentView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(searchView.mas_bottom)?.offset()(10)
            make.height.mas_equalTo()(contentHeight)
            make.width.mas_equalTo()(screenWidth)
        }
        
        // 热搜
        let hotSearchView = UIView.init()
        
        contentView.addSubview(hotSearchView)
        
        hotSearchView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(10)
            make.height.mas_equalTo()(contentHeight / 2)
            make.width.mas_equalTo()(screenWidth)
        }
        
        let hotSearchLabel = UILabel.init()
        
        hotSearchLabel.text = "热门搜索"
        
        hotSearchLabel.textColor = .color166()
        
        hotSearchView.addSubview(hotSearchLabel)
        
        hotSearchLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(5)
            make.left.mas_equalTo()(20)
        }
        
        var previousLabel = UILabel.init()
                
        for i in 0...hotSearchList.count - 1{
            
            let hotLabel = UILabel.init()
            
            hotSearchView.addSubview(hotLabel)
            
            hotLabel.text = hotSearchList[i]
            
            let hotLabelWidth = (screenWidth - 30) / 2
            
            hotLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
                if i % 2 == 0 {
                    make.left.mas_equalTo()(20)
                }else {
                    make.right.mas_equalTo()(-10)
                }
                if i > 1 {
                    make.top.mas_equalTo()(previousLabel.mas_bottom)?.offset()(10)
                }else{
                    make.top.mas_equalTo()(hotSearchLabel.mas_bottom)?.offset()(10)
                }
                make.height.mas_equalTo()(30)
                make.width.mas_equalTo()(hotLabelWidth)
            }
            
            if i % 2 == 1 {
                previousLabel = hotLabel
            }
        
            hotLabel.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(hotSearchClick))
            
            tap.name = hotLabel.text
            
            hotLabel.addGestureRecognizer(tap)
            
        }
    
    }
    
    @objc func hotSearchClick(sender: UITapGestureRecognizer){
        
        goAndSearchResult(sender.name!)
        
    }
    
    //带着关键字到查询列表页
    func goAndSearchResult(_ keyWord: String){
        let controller = BookListViewController()
        
        controller.keyWord = keyWord
        
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
}

extension BookSearchController: UISearchBarDelegate {
    
    @objc func clickCancelButton(){        
        let controller = BookMallViewController()
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    
    /// 点击搜索事件
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        
        let searchText = searchField.text
        
        goAndSearchResult(searchText!)
        
    }
    
}
