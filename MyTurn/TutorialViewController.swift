//
//  TutorialViewController.swift
//  MyTurn
//
//  Created by Simmonds, Eli on 2/28/20.
//  Copyright © 2020 Eli Simmonds. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

open class TutorialViewController: UIViewController  {
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    
    var tutorialModels: [TutorialModel]?
    var tutorialViews: [TutorialView]?
    var tutorialAppearance: TutorialAppearance?

    public convenience init(tutorialPages: [TutorialModel]) {
        self.init()
        
        self.tutorialModels = tutorialPages
    }
    
    public convenience init(tutorialPages: [TutorialModel], tutorialAppearance: TutorialAppearance) {
        self.init(tutorialPages: tutorialPages)
        
        self.tutorialAppearance = tutorialAppearance
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tutorial"
        self.navigationController?.navigationBar.isHidden = false
        self.edgesForExtendedLayout = [] // keeps views from being added below the navigation bar
        
        self.scrollView.backgroundColor = tutorialAppearance?.backgroundColor
        self.scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(self.tutorialModels?.count ?? 1), height: self.preferredContentSize.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.bounces = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.pageControl.numberOfPages = self.tutorialModels?.count ?? 0
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints{(make) -> Void in
            make.edges.equalTo(self.view)
        }
        self.createPages()
        
//        self.scrollView.addSubview(self.pageControl)
//        self.pageControl.snp.makeConstraints{(make) -> Void in
//            make.bottom.equalToSuperview()
//            make.left.right.equalToSuperview()
//            make.height.equalTo(30)
//        }
//        self.scrollView.bringSubviewToFront(self.pageControl)
    }
    
    private func createPages() -> Void {
        guard let tutorialModels = self.tutorialModels else { return }
        guard let appearance = self.tutorialAppearance else { return }
        tutorialViews = Array<TutorialView>()
        var idx = 0
        for tutorial in tutorialModels {
            let tutorialView = TutorialView(tutorial: tutorial, appearance: appearance)
            self.tutorialViews?.append(tutorialView)
            tutorialView.frame = CGRect(x: view.frame.width * CGFloat(idx), y: 0, width: view.frame.width, height: view.frame.height)
            self.scrollView.addSubview(tutorialView)
            
            idx += 1
        }
    }
}

//extension TutorialViewController: UIScrollViewDelegate {
//    /*
//         * default function called when view is scolled. In order to enable callback
//         * when scrollview is scrolled, the below code needs to be called:
//         * slideScrollView.delegate = self or
//         */
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
//        pageControl.currentPage = Int(pageIndex)
//
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//
//
//        /*
//         * below code changes the background color of view on paging the scrollview
//         */
////        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
//
//
//        /*
//         * below code scales the imageview on paging the scrollview
//         */
//        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//
//        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
//
//            self.tutorialViews?[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//            self.tutorialViews?[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//
//        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
//            self.tutorialViews?[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//            self.tutorialViews?[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//
//        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//            self.tutorialViews?[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//            self.tutorialViews?[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//
//        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//            self.tutorialViews?[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            self.tutorialViews?[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//        }
//    }
//}
