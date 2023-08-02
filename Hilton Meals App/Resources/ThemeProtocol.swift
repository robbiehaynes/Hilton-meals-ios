//
//  ThemeProtocol.swift
//  Hilton Meals App
//
//  Created by Robert Haynes on 2019/04/10.
//  Copyright © 2019 Haynes Developments. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var backgroundColour : UIColor { get }
    var textColour : UIColor { get }
    var settingsImage : UIImage { get }
    var logoImage : UIImage { get }
    var enterImage : UIImage { get }
    var haynesDevLogo : UIImage { get }
}
