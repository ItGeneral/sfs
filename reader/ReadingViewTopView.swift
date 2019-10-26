//
//  ReadingViewTopView.swift
//  reader 阅读视图顶部标签
//
//  Created by JiuHua on 2019/10/19.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry

class ReadingViewTopView: UIView {

    /// 书名
    private(set) var bookName:UILabel!
    
    /// 章节名
    private(set) var chapterName:UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addSubviews() {
        // 书名
        bookName = UILabel()
        bookName.font = UIFont.systemFont(ofSize: 14)
        bookName.textColor = .color145()
        bookName.textAlignment = .left
        addSubview(bookName)
        
        // 章节名
        chapterName = UILabel()
        chapterName.font = UIFont.systemFont(ofSize: 14)
        chapterName.textColor = .color145()
        chapterName.textAlignment = .right
        addSubview(chapterName)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        // label的宽度
        let labelW = (w - 15 * (screenWidth / 375)) / 2
        // 书名
        bookName.frame = CGRect(x: 0, y: 15, width: labelW, height: 35)

        // 章节名
        chapterName.frame = CGRect(x: w - labelW, y: 15, width: labelW, height: 35)
    }

}
