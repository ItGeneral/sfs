//
//  ReadViewCell.swift
//  reader
//
//  Created by JiuHua on 2019/10/19.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class ReadViewCell: UITableViewCell {
    
    var chapterModel: BookChapterModel!
    
    class func cell(_ tableView:UITableView) ->ReadViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReadViewCell")
        
        if cell == nil {
            
            cell = ReadViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ReadViewCell")
        }
        
        return cell as! ReadViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {

    }
  
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellUI(){
        // 阅读视图
        let chapterNameLabel = UILabel.init()
        chapterNameLabel.text = chapterModel.name
        chapterNameLabel.textAlignment = .center
        contentView.addSubview(chapterNameLabel)
        chapterNameLabel.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(5)
            make.width.mas_equalTo()(DZM_READ_RECT.width)
        }
        
        let textLabel = UILabel.init()
        textLabel.text = chapterModel.content
        textLabel.numberOfLines = 0
        contentView.addSubview(textLabel)
        let textHeight = chapterModel.heightSize - 70
        textLabel.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.width.mas_equalTo()(DZM_READ_RECT.width)
            make.top.mas_equalTo()(chapterNameLabel.mas_bottom)?.offset()(10)
            make.height.mas_equalTo()(textHeight)
        }
        
        let lineWidth = DZM_READ_RECT.width/2 - 30
        let footView = UIView.init()
        contentView.addSubview(footView)
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
