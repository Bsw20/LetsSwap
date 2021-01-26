//
//  NotificationSceneConstants.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.01.2021.
//

import Foundation
import UIKit

struct NotificationSceneConstants {
    private static var screenSize = UIScreen.main.bounds
    
    static var leadingTrailingOffset = screenSize.width * 0.04
    static var topOffset: CGFloat = 14
    static var firstGapHeight: CGFloat = -2
    static var secondGapHeight: CGFloat = 0
    static var thirdGapHeight: CGFloat = 16
    
    static var interitemSpacing: CGFloat = 46
    
    static var imageViewHeight: CGFloat = 64
    static var chatImageViewSize: CGSize = CGSize(width: 35, height: 24)
    
    static var labelsLeadingOffset: CGFloat = 17
}
