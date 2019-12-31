//
//  UIImageExtensions.swift
//  Cellaret
//
//  Created by Nick Murphy on 12/30/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//
//  Format image into landscape with a white mat.

import Foundation
import UIKit

extension UIImage {
    var mat: UIImage {
        let isLandscape = self.size.width > self.size.height
        let matSize: CGFloat = 30
        let imageRatio: CGFloat = 1.5
        
        var newImageHeight: CGFloat = 0
        var newImageWidth: CGFloat = 0
        
        // Calculate New Image Size
        if isLandscape {
            newImageWidth = self.size.width + (matSize * 2)
            newImageHeight = max(self.size.height + (matSize * 2), newImageWidth * imageRatio)
        } else {
            newImageHeight = self.size.height + (matSize * 2)
            newImageWidth = max(self.size.width + (matSize * 2), newImageHeight * imageRatio)
        }
        
        // Render Image On Mat
        let newImage = UIImageView(frame: CGRect(x: 0, y: 0, width: newImageWidth, height: newImageHeight))
        newImage.backgroundColor = .white
        newImage.contentMode = .center
        newImage.image = self
        
        UIGraphicsBeginImageContextWithOptions(newImage.bounds.size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        newImage.layer.render(in: context)
        
        guard let mattedImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        
        UIGraphicsEndImageContext()
        
        return mattedImage
    }
}
