//
//  ReadHistoryCell.swift
//  reader
//
//  Created by JiuHua on 2019/10/31.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class ReadHistoryCell: UITableViewCell {

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
    
    func drawCellView(historyModel: ReadHistoryModel){
        let cellView = UIView.init()
        
        contentView.addSubview(cellView)
        
        cellView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.width.mas_equalTo()(screenWidth)
            make.height.mas_equalTo()(150)
            make.top.mas_equalTo()(10)
        }
        
        let coverImageView = UIImageView.init()
        
        coverImageView.sd_setImage(with: URL(string: historyModel.coverUrl), placeholderImage: UIImage(named: historyModel.coverUrl))
        
        cellView.addSubview(coverImageView)
        
        coverImageView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(20)
            make.width.mas_equalTo()(100)
            make.height.mas_equalTo()(120)
        }
        
        let bookNameLabel = UILabel.init()
        
        bookNameLabel.text = historyModel.bookName
        
        bookNameLabel.font = UIFont.systemFont(ofSize: 18)
        
        cellView.addSubview(bookNameLabel)
        
        bookNameLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(coverImageView.mas_right)?.offset()(10)
            make.top.mas_equalTo()(10)
        }
        
        let authorLabel = UILabel.init()
        
        authorLabel.text = historyModel.author
        
        authorLabel.font = UIFont.systemFont(ofSize: 18)
        
        cellView.addSubview(authorLabel)
        
        authorLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(coverImageView.mas_right)?.offset()(10)
            make.top.mas_equalTo()(bookNameLabel.mas_bottom)?.offset()(5)
        }
        
        let readTimeLabel = UILabel.init()
        
        readTimeLabel.text = "阅读时间：" +  historyModel.updateTime
        
        readTimeLabel.font = UIFont.systemFont(ofSize: 14)
        
        cellView.addSubview(readTimeLabel)
        
        readTimeLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(coverImageView.mas_right)?.offset()(10)
            make.top.mas_equalTo()(bookNameLabel.mas_bottom)?.offset()(50)
        }
        
        let iconImageView = UIImageView.init()
        
        iconImageView.image = UIImage.init(named: "setting_rightarrow")
        
        cellView.addSubview(iconImageView)
        
        iconImageView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(45)
            make.right.mas_equalTo()(-20)
            make.width.mas_equalTo()(16)
            make.height.mas_equalTo()(16)
        }

        
    }
    

}
