//
//  TimerLabel.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 9/27/19.
//  Copyright © 2019 Eli Simmonds. All rights reserved.
//

import UIKit

class TimerLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        self.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
        // non-op
    }
}
