//
//  LabelUtil.swift
//  reader
//
//  Created by JiuHua on 2019/10/8.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class ReaderUtil: NSObject {

    static func getDeviceUUID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 背景灰色
    class func backgroundColor() -> UIColor {
        return UIColor(r: 232, g: 232, b: 232)
    }
    
    ///字体颜色灰色
    class func color166() -> UIColor {
        return UIColor(r: 166, g: 166, b: 166)
    }
    ///字体黑色
    class func color51() -> UIColor {
        return UIColor(r: 20, g: 20, b: 20)
    }
    
    //蓝色
    class func colorBlue() -> UIColor {
        return UIColor(r: 84, g: 160, b: 249)
    }
    
    //阅读view字体颜色
    class func color145() -> UIColor {
        return UIColor(r: 145, g: 145, b: 145)
    }
    
    class func color230() -> UIColor{
        return UIColor(r: 230, g: 230, b: 230)
    }
    
    class func color46() -> UIColor{
        return UIColor(r: 46, g: 46, b: 46)
    }
    
    //RGB(253, 85, 103) 粉红色
    class func colorPinkRed() -> UIColor{
        return UIColor(r: 253, g: 85, b: 103)
    }
    
    class func color250() -> UIColor {
        return  UIColor(r: 250, g: 250, b: 250)
    }
    
    /// 夜间字体背景灰色 113
    class func color113() -> UIColor {
        return UIColor(r: 113, g: 113, b: 113)
    }
    
    /// 蓝色按钮
    class func colorButtonBlue() -> UIColor {
        return UIColor(r: 61, g: 163, b: 93)
    }
    
    
    //颜色转图片
    func trans2Image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage ?? UIImage()
    }
    
}
