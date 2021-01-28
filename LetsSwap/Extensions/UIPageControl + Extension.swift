//
//  UIPageControl + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//

import Foundation
import UIKit

extension UIPageControl {
    public static func getStandard( currentPageIndex: Int, numberOfPages: Int) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPageIndex
        pageControl.isUserInteractionEnabled = false
        
        pageControl.pageIndicatorTintColor = .detailsGrey()
        pageControl.currentPageIndicatorTintColor = .mainDetailsYellow()
        return pageControl
    }
}
