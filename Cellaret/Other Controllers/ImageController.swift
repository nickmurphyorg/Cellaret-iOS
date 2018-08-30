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
        let documentPath = documentsPath.path
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            for file in files {
                print("File name: \(file)")
            }
        } catch {
            print("Could not find Documents.")
        }
    }
    
    func saveImage(drinkImage: UIImage) -> String? {
        let date = String( Date.timeIntervalSinceReferenceDate )
        let imageID = date.replacingOccurrences(of: ".", with: "-")
        let thumbnailImage = createThumbnail(originalImage: drinkImage)
        
        imageQueue.async { [weak self] in
            
            guard let weakSelf = self else { return }
            
            var images = [ImageObject]()
            
            if let originalImageData = UIImagePNGRepresentation(drinkImage) {
                let originalImageObject = ImageObject(imageName: "\(imageID).png", imageData: originalImageData)
                images.append(originalImageObject)
            } else {
                print("Could not create png from original image.")
            }
            
            if let thumbnailImageData = UIImagePNGRepresentation(thumbnailImage) {
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
    
    func fetchImage(imageID: String) -> UIImage? {
        let path = documentsPath.appendingPathComponent("\(imageID)-small.png").path
        
        guard fileManager.fileExists(atPath: path) else {
            print("Image does not exist at: \n\(path)")
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
    
    func createThumbnail(originalImage: UIImage) -> UIImage {
        let imageWidth = originalImage.size.width
        let imageHeight = originalImage.size.height
        let scaleFactor = screenWidth / imageWidth
        
        if scaleFactor < 1 {
            let newSize = CGSize(width: imageWidth * scaleFactor, height: imageHeight * scaleFactor)
            let alpha = false
            let canvas = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, alpha, pixelScale)
            originalImage.draw(in: canvas)
            
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return thumbnail!
        } else {
            return originalImage
        }
    }
    
}
