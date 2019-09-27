//
//  SwitchView.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 9/27/19.
//  Copyright © 2019 Eli Simmonds. All rights reserved.
//

import UIKit
import SnapKit

class SwitchView: UIView {

    let descriptionLabel = UILabel()
    let toggleSwitch = UISwitch()
    var toggleAction: ((Bool)->())?
    
    let margin: CGFloat = 10
    
    convenience init(text: String, isOn: Bool, action: ((Bool)->())?) {
        self.init()
        
        self.descriptionLabel.text = text
        self.toggleAction = action
        self.toggleSwitch.isOn = isOn
        self.toggleSwitch.addTarget(self, action: #selector(buttonClicked(_:)), for: .valueChanged)
        self.addSubview(descriptionLabel)
        self.addSubview(toggleSwitch)
        
        self.toggleSwitch.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(self).offset(margin)
            make.bottom.right.equalTo(self).offset(-margin)
        }
        self.descriptionLabel.snp.makeConstraints{(make) -> Void in
            make.left.top.equalTo(self).offset(margin)
            make.bottom.equalTo(self).offset(-margin)
            make.right.equalTo(self.toggleSwitch.snp.left).offset(-margin)
        }
    }
    
     @objc func buttonClicked(_ sender: Any) {
        if let toggleAction = self.toggleAction {
            toggleAction(self.toggleSwitch.isOn)
        }
    }
}
