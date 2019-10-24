//
//  ReadPublic.swift
//  reader
//
//  Created by JiuHua on 2019/10/19.
//  Copyright © 2019 JiuHua. All rights reserved.
//

// MARK: -- 判断系统设备
import UIKit
/// 是4
let Is4:Bool = (screenHeight == CGFloat(480) && screenWidth == CGFloat(320))

/// 是5
let Is5:Bool = (screenHeight == CGFloat(568) && screenWidth == CGFloat(320))

/// 是678
let Is678:Bool = (screenHeight == CGFloat(667) && screenWidth == CGFloat(375))

/// 是678P
let Is678P:Bool = (screenHeight == CGFloat(736) && screenWidth == CGFloat(414))

/// 是X系列
let IsX:Bool = (IsX_XS || IsXR_XSMAX)

/// 是X XS
let IsX_XS:Bool = (screenHeight == CGFloat(812) && screenWidth == CGFloat(375))

/// 是XR XSMAX
let IsXR_XSMAX:Bool = (screenHeight == CGFloat(896) && screenWidth == CGFloat(414))

/// StatusBar高度 (IsX ? 44 : 20)
let StatusBarHeight:CGFloat = (IsX ? 44 : 20)

/// 导航栏高度
let NavgationBarHeight:CGFloat = (StatusBarHeight + 44)

/// TabBar高度
let TabBarHeight:CGFloat = (IsX ? 83 : 49)
/// 顶部高度
let topViewHeight = 40 * (screenWidth / 375)
/// 底部高度
let bottomViewHeight = 30 * (screenWidth / 375)

/// 阅读View范围
var DZM_READ_VIEW_RECT:CGRect! {
    
    let rect = DZM_READ_RECT!
    
    return CGRect(x: rect.minX, y: rect.minY + topViewHeight, width: rect.width, height: rect.height - topViewHeight - bottomViewHeight)
}

/// 阅读范围(阅读顶部状态栏 + 阅读View + 阅读底部状态栏)
var DZM_READ_RECT:CGRect! {
    
    // 适配 X 顶部
    let top = SA(isX: StatusBarHeight - 15, 0)
    
    // 适配 X 底部
    let bottom = SA(isX: 30, 0)
    
    return CGRect(x: 15, y: top, width: screenWidth - 30, height: screenHeight - top - bottom)
}

// MARK: -- 屏幕适配

/// 以iPhone6为比例
func SA_SIZE(_ size:CGFloat) ->CGFloat {
    
    return size * (screenWidth / 375)
}

func SA(is45:CGFloat, _ other:CGFloat) ->CGFloat {
    
    return SA(is45, other, other, other, other)
}

func SA(isX:CGFloat, _ other:CGFloat) ->CGFloat {
    
    return SA(isX_XS: isX, isX, other)
}

func SA(is45:CGFloat, _ isX_XS:CGFloat, _ isXR_XSMAX:CGFloat,  _ other:CGFloat) ->CGFloat {
    
    return SA(is45, other, other, isX_XS, isXR_XSMAX)
}

func SA(isX_XS:CGFloat, _ isXR_XSMAX:CGFloat, _ other:CGFloat) ->CGFloat {
    
    return SA(other, other, other, isX_XS, isXR_XSMAX)
}

func SA(_ is45:CGFloat, _ is678:CGFloat, _ is678P:CGFloat, _ isX_XS:CGFloat, _ isXR_XSMAX:CGFloat) ->CGFloat {
    
    if (Is4 || Is5) { return is45
        
    }else if Is678 { return is678
        
    }else if Is678P { return is678P
        
    }else if IsX_XS { return isX_XS
        
    }else { return isXR_XSMAX }
}
/// 动画完成
typealias AnimationCompletion = ()->Void
