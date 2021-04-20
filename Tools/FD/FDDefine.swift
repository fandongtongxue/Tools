//
//  FDDefine.swift
//  FDUIKit
//
//  Created by fandongtongxue on 2020/2/23.
//

import Foundation
import UIKit

public let FD_ScreenWidth = UIScreen.main.bounds.size.width
public let FD_ScreenHeight = UIScreen.main.bounds.size.height
public let FD_NavigationHeight = CGFloat(44)
public let FD_StatusBarHeight = UIApplication.shared.statusBarFrame.size.height
public let FD_LargeTitleHeight = CGFloat(FD_StatusBarHeight > 20 ? 96 : 0)
public let FD_TopHeight = FD_StatusBarHeight + FD_NavigationHeight
public let FD_TabBarHeight = CGFloat(49 + (FD_StatusBarHeight > 20 ? 34 : 0))
public let FD_SafeAreaBottomHeight = CGFloat(FD_StatusBarHeight > 20 ? 34 : 0)
