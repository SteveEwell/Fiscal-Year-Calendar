//
//  Utilities.swift
//  Fiscal Year Calendar
//
//  Created by Stephen Ewell on 5/27/17.
//  Copyright © 2017 Stephen Ewell. All rights reserved.
//

import UIKit

public enum DisplayType {
    case unknown
    case iphoneSmall
    case iphoneMed
    case iphoneLarge
    case iphoneLargePlus
    case ipadMed
    case ipadLarge
}

class Display {
    class var width: CGFloat { return UIScreen.main.bounds.size.width }
    class var height: CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength: CGFloat { return max(width, height) }
    class var minLength: CGFloat { return min(width, height) }
    class var zoomed: Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    class var retina: Bool { return UIScreen.main.scale >= 2.0 }
    class var phone: Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    class var pad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    class var carplay: Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    class var tv: Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    class var displayType: DisplayType {
        if phone && maxLength < 568 {
            return .iphoneSmall
        }
        else if phone && maxLength == 568 {
            return .iphoneMed
        }
        else if phone && maxLength == 667 {
            return .iphoneLarge
        }
        else if phone && maxLength == 736 {
            return .iphoneLargePlus
        }
        else if pad && maxLength == 768 {
            return .ipadMed
        }
        else if pad && maxLength == 1024 {
            return .ipadMed
        }
        return .unknown
    }
}
