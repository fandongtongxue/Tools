//
//  UIImage.swift
//  Tools
//
//  Created by 范东 on 2021/4/26.
//

import Foundation

extension UIImage {
    func addRoundCorner(radiusSize:CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        context?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: size) as! CGPath)
        draw(in: rect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return resultImage
      }
}
