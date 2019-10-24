//
//  BookListTableViewCell.swift
//  reader
//
//  Created by JiuHua on 2019/10/9.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SDWebImage

class BookListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func drawCellView(bookInfo: BookInfoModel) {
        self.contentView.subviews.forEach { (contentView: UIView) in
            contentView.removeFromSuperview()
        }
        let coverImageView = UIImageView.init()
        coverImageView.sd_setImage(with: URL(string: bookInfo.coverUrl), placeholderImage: UIImage(named: bookInfo.coverUrl))
        self.contentView.addSubview(coverImageView)
        coverImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(10)
            make?.left.mas_equalTo()(10)
            make?.width.mas_equalTo()(90)
            make?.height.mas_equalTo()(110)
        }
        
        let nameLabel = UILabel.init()
        nameLabel.text = bookInfo.name
        self.contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        nameLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(10)
            make?.height.mas_equalTo()(30)
            make?.top.mas_equalTo()(10)
        }
        
        let authorLabel = UILabel.init()
        authorLabel.text = bookInfo.author
        authorLabel.textColor = .color51()
        self.contentView.addSubview(authorLabel)
        authorLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(10)
            make?.top.mas_equalTo()(nameLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let typeLabel = UILabel.init()
        typeLabel.text =  bookInfo.type
        typeLabel.textColor = .color51()
        self.contentView.addSubview(typeLabel)
        typeLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(authorLabel.mas_right)?.offset()(20)
            make?.top.mas_equalTo()(nameLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let wordCountLable = UILabel.init()
        wordCountLable.text = "共" + String(format:"%.2f", CGFloat.init(integerLiteral: bookInfo.wordNumber)/10000) + "万字"
        wordCountLable.textColor = .color51()
        self.contentView.addSubview(wordCountLable)
        wordCountLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(10)
            make?.top.mas_equalTo()(authorLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let stateLable = UILabel.init()
        stateLable.text = "已完结"
        stateLable.textColor = .color51()
        self.contentView.addSubview(stateLable)
        stateLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(wordCountLable.mas_right)?.offset()(30)
            make?.top.mas_equalTo()(authorLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let introduceLabel = UILabel.init()
        introduceLabel.text = bookInfo.introduce
        introduceLabel.numberOfLines = 0
        introduceLabel.textColor = .color51()
        self.contentView.addSubview(introduceLabel)
        introduceLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(100)
            make?.width.mas_equalTo()(screenWidth - 20)
            make?.left.mas_equalTo()(10)
            make?.top.mas_equalTo()(coverImageView.mas_bottom)?.offset()(0)
        }
    }

}
