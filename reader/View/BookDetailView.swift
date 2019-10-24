//
//  BookDetailView.swift
//  reader
//
//  Created by JiuHua on 2019/10/13.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class BookDetailView: UIView {

    //详情ui
    static func drawBookDetailView(coverView: UIView, tagAndIntroduceView: UIView, lineView:UIView,
                                   view:UIView, navigationBarHeight:CGFloat, bookDetail: BookInfoModel) {
        view.addSubview(coverView)
        coverView.backgroundColor = .backgroundColor()
        tagAndIntroduceView.backgroundColor = .white
        coverView.backgroundColor = .white
        let height = navigationBarHeight + 50
        coverView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(height)
            make?.height.mas_equalTo()(150)
            make?.width.mas_equalTo()(screenWidth)
        }
        let coverImageView = UIImageView.init()
        coverImageView.sd_setImage(with: URL(string: bookDetail.coverUrl), placeholderImage: UIImage(named: ""))
        coverView.addSubview(coverImageView)
        coverImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(20)
            make?.left.mas_equalTo()(20)
            make?.width.mas_equalTo()(90)
            make?.height.mas_equalTo()(120)
        }
        
        let nameLabel = UILabel.init()
        nameLabel.text = bookDetail.name
        coverView.addSubview(nameLabel)
        nameLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        nameLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(20)
            make?.height.mas_equalTo()(30)
            make?.top.mas_equalTo()(20)
        }
        
        let authorLabel = UILabel.init()
        authorLabel.text = bookDetail.author
        authorLabel.textColor = .color51()
        coverView.addSubview(authorLabel)
        authorLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(20)
            make?.top.mas_equalTo()(nameLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let typeLabel = UILabel.init()
        typeLabel.text = bookDetail.type
        typeLabel.textColor = .color51()
        coverView.addSubview(typeLabel)
        typeLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(authorLabel.mas_right)?.offset()(20)
            make?.top.mas_equalTo()(nameLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let wordCountLable = UILabel.init()
        wordCountLable.text = "共" + String(format:"%.2f", CGFloat.init(integerLiteral: bookDetail.wordNumber)/10000) + "万字"
        wordCountLable.textColor = .color51()
        coverView.addSubview(wordCountLable)
        wordCountLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(20)
            make?.top.mas_equalTo()(authorLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let stateLable = UILabel.init()
        stateLable.text = "已完结"
        stateLable.textColor = .color51()
        coverView.addSubview(stateLable)
        stateLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(wordCountLable.mas_right)?.offset()(30)
            make?.top.mas_equalTo()(authorLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let introduceTextView = UITextView.init()
        introduceTextView.text = bookDetail.introduce
        introduceTextView.autoresizingMask = .flexibleHeight
        introduceTextView.isEditable = false
        introduceTextView.isScrollEnabled = false
        introduceTextView.font = UIFont.italicSystemFont(ofSize: 18)
        introduceTextView.backgroundColor = .white
        tagAndIntroduceView.addSubview(introduceTextView)
        let constrainSize = CGSize.init(width: screenWidth, height: CGFloat(0))
        let size = introduceTextView.sizeThatFits(constrainSize)
        introduceTextView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(size.height)
            if size.width < screenWidth {
                make?.width.mas_equalTo()(screenWidth)
            }else {
                make?.width.mas_equalTo()(size.width)
            }
        }
        
        let tagView = UIView.init()
        tagView.backgroundColor = .white
        tagAndIntroduceView.addSubview(tagView)
        tagView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(introduceTextView.mas_bottom)?.offset()(0)
            make?.height.mas_equalTo()(50)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        let tags = bookDetail.tag.split(separator: ",")
        var lastLabel = UILabel.init()
        for i in 0...tags.count - 1 {
            if i > 3 {
                break
            }
            let tagLabel = UILabel.init()
            tagLabel.backgroundColor = .backgroundColor()
            tagLabel.text = String(tags[i])
            tagLabel.layer.cornerRadius = 15
            tagLabel.clipsToBounds = true
            tagLabel.textAlignment = .center
            tagView.addSubview(tagLabel)
            let textLength = tagLabel.text!.count * 30
            tagLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
                make?.top.mas_equalTo()(12)
                if i == 0 {
                    make?.left.mas_equalTo()(10)
                }else{
                    make?.left.mas_equalTo()(lastLabel.mas_right)?.offset()(10)
                }
                make?.width.mas_equalTo()(textLength)
                make?.height.mas_equalTo()(28)
            }
            lastLabel = tagLabel
        }
        
        view.addSubview(tagAndIntroduceView)
        tagAndIntroduceView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(coverView.mas_bottom)?.offset()(10)
            make?.height.mas_equalTo()(constrainSize.height)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        lineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        view.addSubview(lineView)
        lineView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(10)
            make?.right.mas_equalTo()(-10)
            make?.width.mas_equalTo()(screenWidth - 20)
            make?.height.mas_equalTo()(1)
            make?.top.mas_equalTo()(lastLabel.mas_bottom)?.offset()(15)
        }
        
    }

}
