//
//  UIButtonConfigure+Ex.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit

extension UIButton.Configuration {
    
    static func activeBorderStyle(_ title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.background.cornerRadius = 22
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = UIColor.main
        configuration.baseForegroundColor = UIColor.main
        return configuration
    }
    
    static func inactiveBorderStyle(_ title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.background.cornerRadius = 22
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = UIColor.neutral2
        configuration.baseForegroundColor = UIColor.neutral2
        return configuration
    }
  
    static func activeSolidStyle(_ title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.background.cornerRadius = 22
        configuration.background.backgroundColor = UIColor.main
        configuration.baseForegroundColor = UIColor.white
        return configuration
    }
    
    static func inactiveSolidStyle(_ title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.background.cornerRadius = 22
        configuration.background.backgroundColor = UIColor.neutral2
        configuration.baseForegroundColor = UIColor.white
        return configuration
    }
    
    static func plainStyle(_ title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.baseForegroundColor = UIColor.main
        return configuration
    }
    
}
