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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            return
        }
        
        let inputDevice: AVCaptureDeviceInput
        
        do {
            inputDevice = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            print("BarcodeScanerViewController - \(error)")
            
            return
        }
        
        if (captureSession.canAddInput(inputDevice)) {
            captureSession.addInput(inputDevice)
        } else {
            print("BarcodeScanerViewController - Input device could not be added.")
            
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            print("BarcodeScanerViewController - Could not add metadata output.")
            
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer!)
        view.bringSubviewToFront(scannerLine)
        
        captureSession.startRunning()
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
            
        print(barcodeString)
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
        default:
            return
        }
    }
}
