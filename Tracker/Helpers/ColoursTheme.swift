//
//  ColoursTheme.swift
//  Tracker
//
//  Created by Руслан  on 14.10.2023.
//

import UIKit

enum ColoursTheme {
    static var blackDayWhiteDay: UIColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.ypBlackDay : UIColor.ypWhiteDay
    }
    static var whiteDayBlackDay = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.ypWhiteDay : UIColor.ypBlackDay
    }
    static var whiteLightGray = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.ypWhiteDay : UIColor.yp_LightGray
    }
    static var backgroundNightDay = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.ypBackgroundNight: UIColor.ypBackgroundDay
    }
}
