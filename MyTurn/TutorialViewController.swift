//
//  TutorialViewController.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 2/28/20.
//  Copyright © 2020 Eli Simmonds. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController  {
    var tutorialModels: [TutorialModel]?

    convenience init(tutorialPages: [TutorialModel]) {
        self.init()
        
        self.tutorialModels = tutorialPages
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
