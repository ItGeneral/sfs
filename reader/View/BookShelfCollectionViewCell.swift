//
//  BookShelfCollectionViewCell.swift
//  reader
//
//  Created by JiuHua on 2019/10/2.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SDWebImage

class BookShelfCollectionViewCell: UICollectionViewCell {
    
    func setCollectionView(_ coverUrl: String, bookName:String) {
        self.contentView.backgroundColor = UIColor.white
        
        contentView.subviews.forEach { (cellView: UIView) in
            cellView.removeFromSuperview()
        }
        
        
        let coverImageView = UIImageView.init(image: UIImage.init(named: coverUrl));
        coverImageView.sd_setImage(with: URL(string: coverUrl), placeholderImage: UIImage(named: ""))
        self.contentView.addSubview(coverImageView)
        coverImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.right()?.top().mas_equalTo()(0)
            make?.bottom.mas_equalTo()(-30)
        }
        
        let bookNameLabel = UILabel.init()
        bookNameLabel.text = bookName
        bookNameLabel.textAlignment = .center
        bookNameLabel.numberOfLines = 0
        self.contentView.addSubview(bookNameLabel)
        bookNameLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(coverImageView.mas_bottom)?.offset()(5)
            make?.centerX.mas_equalTo()(coverImageView)
        }
        
    }
    
}
