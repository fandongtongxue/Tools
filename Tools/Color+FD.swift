//
//  Color+FD.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import Foundation
import UIKit

class UIColorEx: NSObject {
    class func randomColor() -> UIColor{
        let color: UIColor = UIColor.init(red: (((CGFloat)((arc4random() % 256)) / 255.0)), green: (((CGFloat)((arc4random() % 256)) / 255.0)), blue: (((CGFloat)((arc4random() % 256)) / 255.0)), alpha: 1.0);
        return color;
    }
}
