//
//  LineViewUtil.swift
//  reader
//
//  Created by JiuHua on 2019/10/21.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class LineViewUtil: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        // 这里控制虚线的样式
        context?.setLineDash(phase: 4, lengths: [20,30,60,30])
        
        context?.fill(self.bounds)
        
        context?.setStrokeColor(UIColor.lightGray.cgColor)
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        context?.strokePath()
        
    }
    
    //MARK:- 绘制虚线
    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, isBottom: Bool = true) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        let y = isBottom == true ? self.layer.bounds.height - lineWidth : 0
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: self.layer.bounds.width, y: y))
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    


}
