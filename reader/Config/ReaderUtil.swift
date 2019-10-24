//
//  LabelUtil.swift
//  reader
//
//  Created by JiuHua on 2019/10/8.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class LabelUtil: NSObject {

    //加载自适应label
    static func autoLabel(label:UILabel,lineHeight:CGFloat){
        label.numberOfLines=0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let text:String = label.text!
        label.attributedText = self.getAttributeStringWithString(text, lineSpace: lineHeight)
        let fontSize = CGSize(width: label.frame.width, height: label.font.lineHeight)
        let rect:CGSize = text.boundingRect(with: fontSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil).size;
        label.frame = CGRect(x:label.frame.origin.x,y:label.frame.origin.y+12,width: rect.width, height: rect.height)
        label.sizeToFit()
    }
    
    //设置行间距
    static fileprivate func getAttributeStringWithString(_ string: String,lineSpace:CGFloat
        ) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        let rang = NSMakeRange(0, CFStringGetLength(string as CFString?))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: rang)
        return attributedString
    }
}
