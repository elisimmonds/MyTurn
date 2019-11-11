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
    private let settingsImageView = UIImageView()
    private let timerLabel = TimerLabel()
    private let resetButton = RoundedButton(title: "Reset")
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private var timer: Timer?
    private var circles = Dictionary<UITouch, CircleView>()
    private let colorArray = [UIColor.systemTeal, UIColor.systemYellow, UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemPink]
    private let circleSize: CGFloat = 125

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.view.isMultipleTouchEnabled = true
        self.createSettingsView()
        self.createTimer()
        self.createResetButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: Touch Recognizers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (self.circles.count == self.colorArray.count) {
                return; // the max touches supported is equal to the number of colors we have available.
            }
            let location = touch.location(in: self.view)
            
            // check if the touch is within the settings button
            if (location.x > self.settingsImageView.frame.origin.x && location.y < (self.settingsImageView.frame.origin.y + self.settingsImageView.frame.size.height)) {
                continue
            }
            
            let circleView = CircleView(color: colorArray[circles.count], size: circleSize)
            self.view.addSubview(circleView)
            circleView.snp.makeConstraints{(make) -> Void in
                make.height.width.equalTo(circleSize)
                make.centerX.equalTo(location.x)
                make.centerY.equalTo(location.y)
            }
            circles[touch] = circleView
        }
        
        if (circles.count >= 2) {
            startTimer()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let circle = self.getCircleForTouch(touch: touch) {
                let location = touch.location(in: self.view)
                circle.snp.updateConstraints{(make) -> Void in
                    make.centerX.equalTo(location.x)
                    make.centerY.equalTo(location.y)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.removeCircleForTouch(touch: touch)
            
            if (circles.count < 2) {
                cancelTimer() // les than two circles on screen
            } else {
                startTimer() // there are still enough players, restart the timer.
            }
        }
        
        if (self.circles.count == 0) {
            UIView.animate(withDuration: 1.0, animations: {
                self.resetButtonAction()
            })
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
    
    private func createResetButton() -> Void {
        self.view.addSubview(self.resetButton)
        self.resetButton.snp.makeConstraints{(make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-30)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        self.resetButton.backgroundColor = UIColor.iconColor
        self.resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
    }
    
    @objc private func resetButtonAction() -> Void {
        self.view.backgroundColor = UIColor.backgroundColor
        self.cancelTimer()
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
        if (self.timer != nil) {
            self.timer?.invalidate()
        }
        self.timerLabel.isHidden = false
        let hapticFeedbackEnabled = UserDefaults.standard.bool(forKey: Constants.hapticFeedbackKey)
        if (hapticFeedbackEnabled) {
            self.feedbackGenerator.prepare()
        }
        
        // Countdown timer and show each second on the label and add impact
        var second = 3
        self.timerLabel.text = "\(second)"
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            second -= 1
            self.timerLabel.text = "\(second)"
            if (hapticFeedbackEnabled) {
                self.feedbackGenerator.impactOccurred()
            }
            if (second == 0) {
                timer.invalidate()
                self.winnerAction()
            }
        }
    }
    
    private func cancelTimer() -> Void {
        self.timerLabel.isHidden = true
        self.timer?.invalidate()
    }
    
    private func winnerAction() -> Void {
        // Choose a random winner
        let randomInt = Int.random(in: 0..<self.circles.count)
        let winningTouch = Array(self.circles.keys)[randomInt]
        
        // Animate the background color change and winning circle color change
        UIView.animate(withDuration: 1.0) {
            self.view.backgroundColor = self.circles[winningTouch]?.color
            self.circles[winningTouch]?.setWinningState()
        }
        
        // Remove all non-winners from the board
        for touch in self.circles.keys {
            if (touch != winningTouch) {
                self.removeCircleForTouch(touch: touch)
            }
        }
    }
    
    // MARK: Circle Model array operations
    private func getCircleForTouch(touch: UITouch) -> CircleView? {
        return circles[touch]
    }
    
    private func removeCircleForTouch(touch: UITouch) -> Void {
        let circleView = self.getCircleForTouch(touch: touch)
        circleView?.removeFromSuperview()
        // now that the view does not exist, we do not need to track it.
        circles.removeValue(forKey: touch)
    }
}

