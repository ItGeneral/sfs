//
//  ReadingMenuTopView.swift
//  reader
//
//  Created by JiuHua on 2019/10/21.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class ReadingMenuTopView: UIView {

    /// 返回
    private var backImageView:UIImageView!
    
    /// 书签
    private var mark:UIButton!
    
    
    var delegate: ReadMenuDelegate!

    private func addSubview() {
   
        backImageView = UIImageView.init(image: UIImage.init(named: "back"))
        addSubview(backImageView)
        backImageView.isUserInteractionEnabled = true
        backImageView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(20)
            make.width.mas_equalTo()(24)
            make.height.mas_equalTo()(24)
            make.top.mas_equalTo()(StatusBarHeight)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickBack))
        backImageView.addGestureRecognizer(tap)
        
        
        mark = UIButton(type:.custom)
        mark.contentMode = .center
        mark.setImage(UIImage(named:"mark")!.withRenderingMode(.alwaysTemplate), for: .normal)
        mark.addTarget(self, action: #selector(addBookToShelf), for: .touchUpInside)
        addSubview(mark)
        mark.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.right.mas_equalTo()(-20)
            make.width.mas_equalTo()(24)
            make.height.mas_equalTo()(24)
            make.top.mas_equalTo()(StatusBarHeight)
        }
        updateMarkButton()
        
    }
    
    /// 点击返回
    @objc private func clickBack() {
        
        delegate.backToPreviousController()
    }
    
    @objc func addBookToShelf(){
        
        delegate.addBookToShelf()
        
        mark.isSelected = !mark.isSelected
        updateMarkButton()
    }
    
    /// 刷新书签按钮显示状态
    func updateMarkButton(){
        if mark.isSelected {
            mark.tintColor = .colorPinkRed()
        }else{
            mark.tintColor = .color230()
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.color46().withAlphaComponent(0.95)
        
        addSubview()
        
    }

}
