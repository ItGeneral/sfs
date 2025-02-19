//
//  LoadingView.swift
//  reader
//
//  Created by JiuHua on 2019/10/16.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    //线的宽度  默认为2
    public var lineWidth: Int = 2
    
    //线的颜色
    public var lineColor: UIColor = .color166()
    
    fileprivate var timer: Timer?
    
    fileprivate var originStart: CGFloat = CGFloat(Double.pi / 2 * 3)  //开始位置
    
    fileprivate var originEnd: CGFloat = CGFloat(Double.pi / 2 * 3 )   //结束位置  都是顶部
    
    fileprivate var isDraw: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10 //圆角  纯属好看
        self.layer.masksToBounds = true
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LoadingView.updateLoading), userInfo: nil, repeats: true)  //创建计时器
        //计时器需要加入到RunLoop中：RunLoop的目的是让你的线程在有工作的时候忙碌，没有工作的时候休眠
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.default)
        self.timer?.fire()
        
    }
    
    @objc func updateLoading () {
        if (self.originEnd == CGFloat(Double.pi / 2 * 3) && isDraw) {//从无到有的过程
            self.originStart += CGFloat(Double.pi / 10)
            if (self.originStart == CGFloat(Double.pi / 2 * 3 + 2 * Double.pi)) {
                self.isDraw = false
                self.setNeedsDisplay() //调用 draw(_ rect: CGRect) 方法
                return
            }
        }
        
        if (self.originStart == CGFloat(Double.pi / 2 * 3 + 2 * Double.pi) && !self.isDraw) { //从有到无
            self.originEnd += CGFloat(Double.pi / 10)
            if (self.originEnd == CGFloat(Double.pi / 2 * 3 + 2 * Double.pi)) {
                self.isDraw = true
                self.originStart = CGFloat(Double.pi / 2 * 3)
                self.originEnd = CGFloat(Double.pi / 2 * 3)
                self.setNeedsDisplay() //调用 draw(_ rect: CGRect) 方法
                return
            }
        }
        self.setNeedsDisplay() //调用 draw(_ rect: CGRect) 方法
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext() //获取上下文
        let center: CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2) // 确定圆心
        let radius = min(self.frame.size.width, self.frame.size.height) / 2 - CGFloat(self.lineWidth) - 20; //半径
        let path: UIBezierPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: self.originStart, endAngle: self.originEnd, clockwise: false) //弧的路径
        context?.addPath(path.cgPath) //将路径、宽度、颜色添加到上下文
        context?.setLineWidth(CGFloat(self.lineWidth)) //
        context?.setStrokeColor(self.lineColor.cgColor) //
        context?.strokePath() //显示弧
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    static func initLoadingView(view: UIView) -> LoadingView{
        let loadingView = LoadingView(frame: CGRect(x: view.frame.size.width/2-50, y: view.frame.size.height/2-50, width: 100, height: 100))
        loadingView.backgroundColor = UIColor(displayP3Red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.3)
        return loadingView
    }

}
