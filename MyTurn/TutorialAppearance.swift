//
//  TutorialAppearance.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 2/29/20.
//  Copyright © 2020 Eli Simmonds. All rights reserved.
//

import Foundation
import UIKit

open class TutorialAppearance {
    var titleFontSize: CGFloat!
    var titleFont: String!
    var descriptionFontSize: CGFloat!
    var descriptionFont: String!
    var backgroundColor: UIColor!
    
    convenience init(titleSize: CGFloat?, titleFont: String?, descriptionSize: CGFloat?, descriptionFont: String?, backgroundColor: UIColor?) {
        self.init()
        self.titleFontSize = titleSize ?? 20
        self.titleFont = titleFont ?? "HelveticaNeue-Bold"
        self.descriptionFontSize = descriptionSize ?? 15
        self.descriptionFont = descriptionFont ?? "HelveticaNeue"
        self.backgroundColor = backgroundColor ?? UIColor.systemGray
    }
}
