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
    var imageView: UIImageView!
    
    var drinkImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: drinkImage)
        imageScrollView.contentSize = imageView.bounds.size
        imageScrollView.addSubview(imageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateMinZoomScaleForSize(imageScrollView.bounds.size)
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.zoomScale = minScale
    }
}

//MARK: - ScrollViewDelegate
extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = imageScrollView.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize .width) / 2 : 0
        
        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}
