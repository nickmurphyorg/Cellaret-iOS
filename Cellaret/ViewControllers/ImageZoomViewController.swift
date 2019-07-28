//
//  ImageZoomViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 6/19/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import UIKit

class ImageZoomViewController: UIViewController {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var drinkImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = drinkImage
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let drinkImage = drinkImage {
            setMinZoomScaleForImageSize(drinkImage.size)
        }
    }
}

//MARK: - ScrollViewDelegate
extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

//MARK: - Double Tap Gesture
extension ImageZoomViewController {
    @IBAction func doubleTapImage(_ sender: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
            imageScrollView.zoom(to: zoomRectangle(scale: imageScrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
        }
    }
}

//MARK: - Helper Methods
extension ImageZoomViewController {
    fileprivate func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
        let widthScale = view.frame.width / imageSize.width
        let heightScale = view.frame.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        // Scale the image down to fit in the view
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.zoomScale = minScale
        
        // Set the image frame size after scaling down
        let imageWidth = imageSize.width * minScale
        let imageHeight = imageSize.height * minScale
        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.frame = newImageFrame

        centerImage()
    }
    
    private func centerImage() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = view.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        zoomRect.origin.x = center.x - (center.x * imageScrollView.zoomScale)
        zoomRect.origin.y = center.y - (center.y * imageScrollView.zoomScale)
        
        return zoomRect
    }
}
