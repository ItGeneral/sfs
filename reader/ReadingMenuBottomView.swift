//
//  ReadingMenuBottomView.swift
//  reader
//
//  Created by JiuHua on 2019/10/21.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class ReadingMenuBottomView: UIView {

    /// 目录
    private var catalogue:UIButton!
    
    /// 设置
    private var setting:UIImageView!
    
    ///上一章
    var previousChapter:UILabel!
    
    ///下一章
    var nextChapter:UILabel!
    
    /// 方法代理
    var delegate:ReadMenuDelegate!
    
    /// 当前章节
    var currentChapterModel:BookChapterModel! = BookChapterModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.color46().withAlphaComponent(0.95)
        
        addSubview()
        
    }
    
    private func addSubview() {
        
        previousChapter = UILabel.init()
        previousChapter.text = "上一章"
        previousChapter.isUserInteractionEnabled = true
        addSubview(previousChapter)
        previousChapter.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(15)
            make.width.mas_equalTo()(55)
            make.top.mas_equalTo()(20)
        }
        previousChapter.textColor = .color230()
        let previousChapterTap = UITapGestureRecognizer.init(target: self, action: #selector(loadPreviousChapter))
        previousChapter.addGestureRecognizer(previousChapterTap)
        
        catalogue = UIButton.init()
        catalogue.setImage(UIImage.init(named: "bar_content")!.withRenderingMode(.alwaysOriginal), for: .normal)
        catalogue.setTitleColor(UIColor.color230(), for: .normal)
        catalogue.addTarget(self, action: #selector(showContentView), for: .touchUpInside)
        addSubview(catalogue)
        let catalogueLeft = screenWidth / 2 - 25
        catalogue.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(catalogueLeft)
            make.top.mas_equalTo()(20)
            make.width.mas_equalTo()(25)
            make.height.mas_equalTo()(25)
        }
        
        
        nextChapter = UILabel.init()
        nextChapter.text = "下一章"
        nextChapter.isUserInteractionEnabled = true
        addSubview(nextChapter)
        nextChapter.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.right.mas_equalTo()(-20)
            make.width.mas_equalTo()(55)
            make.top.mas_equalTo()(20)
        }
        nextChapter.textColor = .color230()
        let nextChapterTap = UITapGestureRecognizer.init(target: self, action: #selector(loadNextChapter))
        nextChapter.addGestureRecognizer(nextChapterTap)
        
    }
    
    
    @objc func loadNextChapter(){
        if currentChapterModel.nextId == 0 {
            nextChapter.textColor = .color166()
        }else{
            nextChapter.textColor = .color230()
            delegate.loadNextOrPreviousChapter(isNext: true)
        }
    }
    
    @objc func loadPreviousChapter(){
        if currentChapterModel.previousId == 0 {
            previousChapter.textColor = .color166()
        }else {
            previousChapter.textColor = .color230()
            delegate.loadNextOrPreviousChapter(isNext: false)
        }
        
    }
    
    /// 点击目录
    @objc func showContentView(){
        
        delegate.clickCatalogue()
        
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
