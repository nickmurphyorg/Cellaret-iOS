//
//  BarcodeScanerViewController.swift
//  Cellaret
//
//  Created by Nick Murphy on 9/15/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScanerViewController: UIViewController {
    
    @IBOutlet weak var scannerLine: UIView!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var editDrinkDelegate: EditDrinkDelegate?
    var downloadedDrink: Drink!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadedDrink = Drink()
        
        setupBarcodeScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

// MARK: - AVCapture Setup
extension BarcodeScanerViewController {
    func setupBarcodeScanner() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("BarcodeScanerViewController - AVFoundation failed to get camera device.")
            setupBarcodeScannerFailed()
            
            return
        }
        
        let inputDevice: AVCaptureDeviceInput
        
        do {
            inputDevice = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            print("BarcodeScanerViewController - \(error)")
            setupBarcodeScannerFailed()
            
            return
        }
        
        if (captureSession.canAddInput(inputDevice)) {
            captureSession.addInput(inputDevice)
        } else {
            print("BarcodeScanerViewController - Input device could not be added.")
            setupBarcodeScannerFailed()
            
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            print("BarcodeScanerViewController - Could not add metadata output.")
            setupBarcodeScannerFailed()
            
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer!)
        view.bringSubviewToFront(scannerLine)
        
        captureSession.startRunning()
    }
    
    func setupBarcodeScannerFailed() {
        performSegue(withIdentifier: segueName.drinkForm.rawValue, sender: nil)
    }
}

// MARK: - AVCapture Delegate
extension BarcodeScanerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        guard let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            var barcodeString = readableObject.stringValue else {
                    return
            }
        
        // Drop leading zero from EAN13 barcodes
        if readableObject.type == AVMetadataObject.ObjectType.ean13 &&
            barcodeString.count == 13 &&
            barcodeString.hasPrefix("0") {
            let barcodeStringIndex = barcodeString.index(barcodeString.startIndex, offsetBy: 1)
            barcodeString = String(barcodeString[barcodeStringIndex...])
        }
        
        downloadDrink(barcodeString)
    }
}

// MARK: - Download Drink Data
extension BarcodeScanerViewController {
    func downloadDrink(_ upc: String) {
        ProductAPIController.shared.getProduct(UPC: upc, completion: {[weak self] (drinkData) in
            guard let drinkData = drinkData,
                let weakSelf = self else { return }

            weakSelf.downloadedDrink.name = drinkData.item_attributes.title
            weakSelf.downloadedDrink.upc = drinkData.item_attributes.upc
            
            // Download Drink Image If Available And Save It
            ImageController.shared.downloadImage(drinkData.item_attributes.image, completion: {(drinkImage) in
                if let drinkImage = drinkImage {
                    weakSelf.downloadedDrink?.image = drinkImage
                    weakSelf.downloadedDrink.imageId = ImageController.shared.saveImage(drinkImage: drinkImage)
                }
                
                DispatchQueue.main.async {
                    weakSelf.performSegue(withIdentifier: segueName.drinkForm.rawValue, sender: nil)
                }
            })
        })
    }
}

// MARK: - Actions
extension BarcodeScanerViewController {
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func NoBarcode(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueName.drinkForm.rawValue, sender: nil)
    }
}

// MARK: - Navigation
extension BarcodeScanerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueName.drinkForm.rawValue:
            let destinationViewController = segue.destination as! EditDrinkTableViewController
            destinationViewController.editDrinkDelegate = editDrinkDelegate
            destinationViewController.drinkData = downloadedDrink
        default:
            return
        }
    }
}
