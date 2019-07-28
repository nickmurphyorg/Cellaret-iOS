//
//  ImageController.swift
//  Cellaret
//
//  Created by Nick Murphy on 8/15/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    static let shared = ImageController()
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let screenWidth = UIScreen.main.bounds.width
    let pixelScale: CGFloat = 0.0
    
    private let imageQueue = DispatchQueue(label: "org.nickmurphy.Cellaret.imageQueue", qos: .background)
    
    private init() {
        // For Debugging Purposes

        let documentPath = documentsPath.path
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            print("Number of files in Documents: \(files.count)")
        } catch {
            print("Could not find Documents.")
        }
    }
    
    func saveImage(drinkImage: UIImage) -> String? {
        let date = String( Date.timeIntervalSinceReferenceDate )
        let imageID = date.replacingOccurrences(of: ".", with: "-")
        let fullsizeImage = createImage(imageSize.original, for: drinkImage)
        let thumbnailImage = createImage(imageSize.small, for: drinkImage)
        
        imageQueue.async { [weak self] in
            guard let weakSelf = self else { return }
            
            var images = [ImageObject]()
            
            if let fullsizeImage = fullsizeImage, let originalImageData = fullsizeImage.pngData() {
                let originalImageObject = ImageObject(imageName: "\(imageID).png", imageData: originalImageData)
                
                images.append(originalImageObject)
            } else {
                print("Could not create png from fullsize image.")
            }
            
            if let thumbnailImage = thumbnailImage, let thumbnailImageData = thumbnailImage.pngData() {
                let thumbnailImageObject = ImageObject(imageName: "\(imageID)-small.png", imageData: thumbnailImageData)
                
                images.append(thumbnailImageObject)
            } else {
                print("Could not create png from thumbnail image.")
            }
            
            do {
                for imageObject in images {
                    let filePath = weakSelf.documentsPath.appendingPathComponent("\(imageObject.imageName)")
                    
                    try imageObject.imageData.write(to: filePath, options: .atomic)
                    
                    print("\(imageObject.imageName) saved.")
                }
            } catch {
                print("Image could not be saved: \n\(error)")
            }
        }
        
        return imageID
    }
    
    func fetchImage(imageID: String, _ imageSize: imageSize) -> UIImage? {
        let path: String!
        
        switch imageSize {
        case .small:
            path = documentsPath.appendingPathComponent("\(imageID)-small.png").path
        case .original:
            path = documentsPath.appendingPathComponent("\(imageID).png").path
        }
        
        guard fileManager.fileExists(atPath: path) else {
            print("Image does not exist at: \n\(path!)")
            
            return nil
        }
        
        if let imageData = UIImage(contentsOfFile: path) {
            return imageData
        } else {
            return nil
        }
    }
    
    func deleteImage(imageID: String) {
        let images = ["\(imageID).png", "\(imageID)-small.png"]
        
        imageQueue.async { [weak self] in
            guard let weakSelf = self else { return }
            
            do {
                for image in images {
                    try weakSelf.fileManager.removeItem(at: weakSelf.documentsPath.appendingPathComponent(image) )
                    
                    print("Removed: \(image)")
                }
            } catch {
                print("Image with ID \(imageID) could not be deleted.\n\(error)")
            }
        }
    }
    
    func createImage(_ size: imageSize, for image: UIImage) -> UIImage? {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        var scaleFactor: CGFloat = 1.0
        
        // Set Scale Percentage For Small Image Size
        if size == imageSize.small && (screenWidth / imageWidth) < 1.0 {
            scaleFactor = screenWidth / imageWidth
        }
        
        let imageSize = CGSize(width: imageWidth * scaleFactor, height: imageHeight * scaleFactor)
        let alpha = false
        let canvas = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, alpha, pixelScale)
        
        image.draw(in: canvas)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
