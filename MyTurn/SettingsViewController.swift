//
//  SettingsViewController.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 9/27/19.
//  Copyright © 2019 Eli Simmonds. All rights reserved.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor
        self.title = "Settings"
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(self.dismissSelf))
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationController?.navigationBar.isHidden = false
        self.edgesForExtendedLayout = [] // keeps views from being added below the navigation bar
        
        self.createSettingsViews()
    }
    
    private func createSettingsViews() -> Void {
        let toggle = self.hapticFeedbackToggle()
        self.view.addSubview(toggle)
        let topInset = self.view.safeAreaInsets.top
        toggle.snp.makeConstraints{(make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(topInset)
        }
    }
    
    private func hapticFeedbackToggle() -> UIView {
        let toggleAction = { (switchState: Bool) -> Void in
            UserDefaults.standard.set(switchState, forKey: Constants.hapticFeedbackKey)
        }
        let state = UserDefaults.standard.bool(forKey: Constants.hapticFeedbackKey)
        if state == nil { state = true } // default to set ON
        let soundToggle = SwitchView(text: "Haptic Feedback", isOn: state, action: toggleAction)
        return soundToggle
    }
    
    private func soundToggle() -> UIView {
        let soundEffectsKey = "soundEffectsEnabled"
        let toggleAction = { (switchState: Bool) -> Void in
            UserDefaults.standard.set(switchState, forKey: soundEffectsKey)
        }
        let state = UserDefaults.standard.bool(forKey: soundEffectsKey)
        let soundToggle = SwitchView(text: "Sound Effects", isOn: state, action: toggleAction)
        return soundToggle
    }
    
    @objc func dismissSelf() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
}
