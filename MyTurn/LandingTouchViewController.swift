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
    
    private let settingsImageView = UIImageView()
    private let timerLabel = TimerLabel()
    private var timer: Timer?
    private var circles = [CircleModel]()
    private let colorArray = [UIColor.systemTeal, UIColor.systemYellow, UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemPink]
    private let circleSize: CGFloat = 50

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.createSettingsView()
        self.createTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: Touch Recognizers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        
        // check if the touch is within the settings button
        if (location.x > self.settingsImageView.frame.origin.x && location.y < (self.settingsImageView.frame.origin.y + self.settingsImageView.frame.size.height)) {
            return
        }
        
        let circleView = CircleView(color: colorArray[circles.count], size: circleSize)
        let circleObject = CircleModel(circleView: circleView, touch: touch)
        self.view.addSubview(circleView)
        circleView.snp.makeConstraints{(make) -> Void in
            make.height.width.equalTo(circleSize)
            make.centerX.equalTo(location.x)
            make.centerY.equalTo(location.y)
        }
        circles.append(circleObject)
        
        if (circles.count >= 2) {
            startTimer()
        }
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
        
        if (circles.count < 2) {
            cancelTimer() // les than two circles on screen
        } else {
            startTimer() // there are still enough players, restart the timer.
        }
    }
    
    // MARK: Private Methods
    /// Create & configure the settings icon
    private func createSettingsView() -> Void {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(settingsButtonAction(tapGestureRecognizer:)))
        self.settingsImageView.isUserInteractionEnabled = true
        self.settingsImageView.addGestureRecognizer(tapGestureRecognizer)
        // Change the settings image color to match our color assets.
        let settingsImage = UIImage.init(named: "SettingsIcon")?.withTintColor(UIColor.iconColor, renderingMode: .automatic)
        self.settingsImageView.image = settingsImage
        
        self.view.addSubview(self.settingsImageView)
        self.settingsImageView.snp.makeConstraints{(make) -> Void in
            make.height.width.equalTo(40)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(self.view).offset(UIApplication.shared.statusBarFrame.height)
        }
    }
    
    /// Display the Settings screen modally
    @objc private func settingsButtonAction(tapGestureRecognizer: UITapGestureRecognizer) -> Void {
        let settingsViewController = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    private func createTimer() -> Void {
        self.view.addSubview(self.timerLabel)
        self.timerLabel.snp.makeConstraints{(make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(UIApplication.shared.statusBarFrame.height)
        }
        self.timerLabel.isHidden = true
    }
    
    private func startTimer() -> Void {
        self.timerLabel.isHidden = false
        
        var second = 3
        self.timerLabel.text = "\(second)"
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            second -= 1
            self.timerLabel.text = "\(second)"
            if (second == 0) {
                // TODO: Winner completion animation
                timer.invalidate()
            }
        }
    }
    
    private func cancelTimer() {
        self.timerLabel.isHidden = true
        self.timer?.invalidate()
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

