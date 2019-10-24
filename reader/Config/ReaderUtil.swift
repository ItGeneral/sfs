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
    
}




//public extension UIView {
//    enum ViewSide {
//        case top
//        case right
//        case bottom
//        case left
//    }
//    func createBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {
//        switch side {
//        case .top:
//            // Bottom Offset Has No Effect
//            // Subtract the bottomOffset from the height and the thickness to get our final y position.
//            // Add a left offset to our x to get our x position.
//            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
//            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                    y: 0 + topOffset,
//                                                    width: self.frame.size.width - leftOffset - rightOffset,
//                                                    height: thickness), color: color)
//        case .right:
//            // Left Has No Effect
//            // Subtract bottomOffset from the height to get our end.
//            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
//                                                    y: 0 + topOffset,
//                                                    width: thickness,
//                                                    height: self.frame.size.height), color: color)
//        case .bottom:
//            // Top has No Effect
//            // Subtract the bottomOffset from the height and the thickness to get our final y position.
//            // Add a left offset to our x to get our x position.
//            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
//            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                    y: self.frame.size.height-thickness-bottomOffset,
//                                                    width: self.frame.size.width - leftOffset - rightOffset,
//                                                    height: thickness), color: color)
//        case .left:
//            // Right Has No Effect
//            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                    y: 0 + topOffset,
//                                                    width: thickness,
//                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
//        }
//    }
//    func createViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {
//        switch side {
//        case .top:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
//            return border
//        case .right:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
//                                                                            y: 0 + topOffset, width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
//            return border
//        case .bottom:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: self.frame.size.height-thickness-bottomOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
//            return border
//        case .left:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
//            return border
//        }
//    }
//    func addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
//        switch side {
//        case .top:
//            // Add leftOffset to our X to get start X position.
//            // Add topOffset to Y to get start Y position
//            // Subtract left offset from width to negate shifting from leftOffset.
//            // Subtract rightoffset from width to set end X and Width.
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                   y: 0 + topOffset,
//                                                                   width: self.frame.size.width - leftOffset - rightOffset,
//                                                                   height: thickness), color: color)
//            self.layer.addSublayer(border)
//        case .right:
//            // Subtract the rightOffset from our width + thickness to get our final x position.
//            // Add topOffset to our y to get our start y position.
//            // Subtract topOffset from our height, so our border doesn't extend past teh view.
//            // Subtract bottomOffset from the height to get our end.
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
//                                                                   y: 0 + topOffset, width: thickness,
//                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            self.layer.addSublayer(border)
//        case .bottom:
//            // Subtract the bottomOffset from the height and the thickness to get our final y position.
//            // Add a left offset to our x to get our x position.
//            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                   y: self.frame.size.height-thickness-bottomOffset,
//                                                                   width: self.frame.size.width - leftOffset - rightOffset, height: thickness), color: color)
//            self.layer.addSublayer(border)
//        case .left:
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                   y: 0 + topOffset,
//                                                                   width: thickness,
//                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            self.layer.addSublayer(border)
//        }
//    }
//    func addViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
//        switch side {
//        case .top:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
//            self.addSubview(border)
//
//        case .right:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
//                                                                            y: 0 + topOffset, width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
//            self.addSubview(border)
//
//        case .bottom:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: self.frame.size.height-thickness-bottomOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
//            self.addSubview(border)
//        case .left:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
//            self.addSubview(border)
//        }
//    }
//
//    //////////
//    // Private: Our methods call these to add their borders.
//    //////////
//
//
//    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
//        let border:CALayer = CALayer()
//        border.frame = frame
//        border.backgroundColor = color.cgColor
//        return border
//    }
//
//    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
//        let border:UIView = UIView.init(frame: frame)
//        border.backgroundColor = color
//        return border
//    }

//}
