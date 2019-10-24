//
//  ReadingContentView.swift
//  reader
//
//  Created by JiuHua on 2019/10/19.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class ReadingContentView: UIView {

    var frameRef:CTFrame? {
        didSet{
            if frameRef != nil { setNeedsDisplay() }
        }
    }
    
    /// 当前页模型(使用contentSize绘制)
    var pageModel:BookChapterModel! {
        
        didSet{
            
            frameRef = ReadCoreText.GetFrameRef(attrString: NSAttributedString.init(string: pageModel.content), rect: CGRect(origin: CGPoint.zero, size: CGSize.init(width: screenWidth, height: pageModel!.heightSize)))
        }
    }
    
    
    /// 当前页内容(使用固定范围绘制)
    var content:NSAttributedString! {
        
        didSet{
            
            frameRef = ReadCoreText.GetFrameRef(attrString: content, rect: CGRect(origin: CGPoint.zero, size: DZM_READ_VIEW_RECT.size))
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 正常使用
        backgroundColor = UIColor.clear
    }
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height);
        
        ctx?.scaleBy(x: 1.0, y: -1.0);
        
        CTFrameDraw(frameRef!, ctx!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
