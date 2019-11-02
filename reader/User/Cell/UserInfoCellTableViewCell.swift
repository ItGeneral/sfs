//
//  UserInfoCellTableViewCell.swift
//  reader
//
//  Created by JiuHua on 2019/10/30.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class UserInfoCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, userCell: UserCellModel) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let iconImageView = UIImageView.init()
        iconImageView.image = UIImage.init(named: userCell.cellIcon)
        self.contentView.addSubview(iconImageView)
        iconImageView.mas_makeConstraints{ (make: MASConstraintMaker?) in
            make?.width.height().mas_equalTo()(24)
            make?.centerY.mas_equalTo()(0)
            make?.left.mas_equalTo()(20)
        }
        
        let contentLabel = UILabel.init()
        contentLabel.text = userCell.cellName
        self.contentView.addSubview(contentLabel)
        contentLabel.mas_makeConstraints{ (make: MASConstraintMaker?) in
            make?.centerY.mas_equalTo()(iconImageView)
            make?.left.mas_equalTo()(iconImageView.mas_right)?.offset()(20)
        }
        
        let arrowImageView = UIImageView.init()
        arrowImageView.image = UIImage.init(named: "setting_rightarrow")
        self.contentView.addSubview(arrowImageView)
        arrowImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.right.equalTo()(-40)
            make?.centerY.mas_equalTo()(iconImageView)
            make?.height.mas_equalTo()(16)
            make?.width.mas_equalTo()(8)
        }
    }

}
