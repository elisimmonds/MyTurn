//
//  RoundedButton.swift
//  MyTurn
//
//  Created by Eli Simmonds on 9/28/19.
//  Copyright © 2019 Eli Simmonds. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    convenience init(title: String) {
        self.init()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor.secondaryColor
        self.setTitle(title, for: .normal)
    }
    
}
