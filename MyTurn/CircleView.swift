//
//  CircleView.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 9/26/19.
//  Copyright © 2019 Eli Simmonds. All rights reserved.
//

import UIKit
import SnapKit

class CircleView: UIView {
    public var color: UIColor?
    
    private var circleLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    private var indicator: UIView!
    
    private let innerCircleView = UIView()
    private var size: CGFloat = 0
    private var offset: CGFloat = 10

    convenience init(color: UIColor, size: CGFloat) {
        self.init()
        
        self.size = size
        self.color = color
        self.innerCircleView.backgroundColor = color
        self.innerCircleView.layer.cornerRadius = (size - (self.offset * 2)) / 2
        self.innerCircleView.clipsToBounds = true
        self.addSubview(self.innerCircleView)
        self.innerCircleView.snp.makeConstraints{(make) -> Void in
            make.top.left.equalTo(self).offset(self.offset)
            make.bottom.right.equalTo(self).offset(-self.offset)
        }
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: size / 2.0, y: size / 2.0), radius: (size - (self.offset * 2))/2, startAngle: CGFloat(Double.pi * -0.5), endAngle: CGFloat(Double.pi * 1.5), clockwise: true)

        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circlePath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.backgroundColor.cgColor
        backgroundLayer.lineWidth = self.offset
        backgroundLayer.strokeEnd = 0.0
        layer.addSublayer(backgroundLayer)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = color.cgColor
        circleLayer.lineWidth = self.offset
        circleLayer.strokeEnd = 0.0
        layer.addSublayer(circleLayer)
    }
    
    public func setWinningState() -> Void {
        backgroundLayer.strokeColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
    }
    
    public func startAnimation(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
        
        if let _ = indicator {
            // remove the rotating "load" animation if it already exists.
            indicator.layer.removeAnimation(forKey: "orbit")
        }
        
        indicator = UIView(frame:CGRect(x: 0, y: 0, width: size, height: size))
        indicator.backgroundColor = UIColor.red
        let boundingRect = CGRect(x: -150, y: -150, width: 300, height: 300)
        
        let orbit = CAKeyframeAnimation()
        orbit.keyPath = "position";
        orbit.path = CGPath(ellipseIn: boundingRect, transform: nil)
        orbit.duration = duration
        orbit.isAdditive = true
        orbit.repeatCount = 1
        orbit.calculationMode = CAAnimationCalculationMode.paced;
        orbit.rotationMode = CAAnimationRotationMode.rotateAuto;
        
        indicator.layer.add(orbit, forKey: "orbit")
    }

}
