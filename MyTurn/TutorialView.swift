//
//  TutorialView.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 2/28/20.
//  Copyright © 2020 Eli Simmonds. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TutorialView: UIView {

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()
    
    let margin: CGFloat = 10
    
    convenience init(title: String, description: String, image: UIImage?) {
        self.init()
        
        self.imageView.image = image
        self.titleLabel.text = description
        self.descriptionLabel.text = description
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        self.imageView.snp.makeConstraints{(make) -> Void in
            make.top.equalToSuperview().offset(margin)
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().inset(margin)
            make.height.width.equalTo(100)
        }
        self.titleLabel.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(self.imageView).offset(margin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.descriptionLabel.snp.top)
        }
        self.descriptionLabel.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(self.titleLabel).offset(margin)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(margin)
        }
    }
    
    @objc func buttonClicked(_ sender: Any) {
        
    }
}
