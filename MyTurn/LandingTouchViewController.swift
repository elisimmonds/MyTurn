//
//  LandingTouchViewController.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 9/26/19.
//  Copyright © 2019 Eli Simmonds. All rights reserved.
//

import UIKit
import SnapKit

class LandingTouchViewController: UIViewController {
    private struct CircleModel {
        init(circleView: CircleView, touch: UITouch) {
            self.view = circleView
            self.touch = touch
        }
        var view: CircleView!
        var touch: UITouch!
    }
    
    private var circles = [CircleModel]()
    private let colorArray = [UIColor.systemTeal, UIColor.systemYellow, UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemPink]
    private let circleSize: CGFloat = 50

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGray4
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: Touch Recognizers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        
        let circleView = CircleView(color: colorArray[circles.count], size: circleSize)
        let circleObject = CircleModel(circleView: circleView, touch: touch)
        self.view.addSubview(circleView)
        circleView.snp.makeConstraints{(make) -> Void in
            make.height.width.equalTo(circleSize)
            make.centerX.equalTo(location.x)
            make.centerY.equalTo(location.y)
        }
        circles.append(circleObject)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        
        if let circle = self.getCircleForTouch(touch: touch) {
            circle.view.snp.updateConstraints{(make) -> Void in
                make.centerX.equalTo(location.x)
                make.centerY.equalTo(location.y)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        self.removeCircleForTouch(touch: touch)
    }
    
    // MARK: Circle Model array operations
    private func getCircleForTouch(touch: UITouch) -> CircleModel? {
        for circle in circles {
            if touch == circle.touch {
                return circle
            }
        }
        
        return nil
    }
    
    private func removeCircleForTouch(touch: UITouch) -> Void {
        var idx: Int = 0
        for circle in circles {
            if touch == circle.touch {
                circle.view.removeFromSuperview()
                circles.remove(at: idx)
                break;
            }
            idx += 1
        }
    }
}

