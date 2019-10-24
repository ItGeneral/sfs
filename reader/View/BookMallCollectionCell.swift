//
//  BookMallCollectionCell.swift
//  reader
//
//  Created by JiuHua on 2019/10/4.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SDWebImage

class BookMallCollectionCell: UICollectionViewCell {
    
    //每个cell样式
    func setCollectionView(_ coverUrl: String, bookName:String) {
        //防止视图重叠，删除已有的视图
        self.contentView.subviews.forEach { (subView: UIView) in
            subView.removeFromSuperview()
        }
        self.contentView.backgroundColor = UIColor.white
        let coverImageView = UIImageView.init()
        coverImageView.sd_setImage(with: URL(string: coverUrl), placeholderImage: UIImage(named: ""))
        self.contentView.addSubview(coverImageView)
        coverImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.right().mas_equalTo()(0)
            make?.bottom.mas_equalTo()(-50)
            make?.height.mas_equalTo()(150)
        }
        
         let bookNameLabel = UILabel.init()
        bookNameLabel.text = bookName
        bookNameLabel.textAlignment = .center
        bookNameLabel.numberOfLines = 0
        self.contentView.addSubview(bookNameLabel)
        bookNameLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(coverImageView.mas_bottom)?.offset()(5)
            make?.centerX.mas_equalTo()(coverImageView)
            make?.width.mas_equalTo()((screenWidth - 40)/3)
            make?.height.mas_equalTo()(45)
        }
        bookNameLabel.sizeToFit()
    }
    
    //第一个section的cell ui
    func setSectionOneView(type: String, icon:String){
        self.contentView.subviews.forEach { (subView: UIView) in
            subView.removeFromSuperview()
        }
        
        let viewWidth = (screenWidth - 100)/4
        let iconImageView = UIImageView.init()
        iconImageView.image = UIImage.init(named: icon)
        self.contentView.addSubview(iconImageView)
        iconImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(10)
            make?.top.mas_equalTo()(10)
            make?.width.mas_equalTo()(50)
            make?.height.mas_equalTo()(50)
        }
        let typeLable = UILabel.init()
        typeLable.text = type
        typeLable.textAlignment = .center
        self.contentView.addSubview(typeLable)
        typeLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.width.mas_equalTo()(viewWidth)
            make?.top.mas_equalTo()(iconImageView.mas_bottom)?.offset()(10)
        }
    }
    
}
