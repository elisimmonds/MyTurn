//
//  TutorialModel.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 2/28/20.
//  Copyright © 2020 Eli Simmonds. All rights reserved.
//

import Foundation
import UIKit

open class TutorialModel {
    var title = ""
    var description = ""
    var image: UIImage?
    
    init(title: String, description: String, image: UIImage?) {
        self.title = title
        self.description = description
        self.image = image
    }
}
