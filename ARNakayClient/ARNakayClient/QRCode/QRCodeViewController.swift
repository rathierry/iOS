//
//  QRCodeViewController.swift
//  ARNakayClient
//
//  Created by NelliStudio on 21/11/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var btnStartStop: UIButton!
    @IBOutlet weak var lblString: UILabel!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init view
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        addSlideMenuButton()
        self.title = "QRCode"
        
        // init elem
        viewPreview.layer.cornerRadius = 5
        btnStartStop.layer.cornerRadius = 5
        captureSession = nil;
        lblString.text = "Barcode discription...";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // start scan
    func startReading() -> Bool {
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // TODO: Do the rest of your work...
            
        } catch let error as NSError {
            print("\nError: ", error)
            return false
        }
        
        // initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = viewPreview.layer.bounds
        viewPreview.layer.addSublayer(videoPreviewLayer)
        
        // check for metadata
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
        print(captureMetadataOutput.availableMetadataObjectTypes)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // start video capture
        captureSession?.startRunning()
        
        if let qrCodeFrameView = viewPreview {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 1
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
        return true
    }
    
    // stop scan
    @objc func stopReading() -> Void {
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer.removeFromSuperlayer()
    }
    
    // capture
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            viewPreview.frame = CGRect.zero
            lblString.text = "No QR code is detected"
            print("\nNo QR code is detected")
            return
        }
        
        for data in metadataObjects {
            let metaData = data
            print("\nRESULT: ", metaData.description)
            
            // get the metadata object.
            let transformed = videoPreviewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
            
            // here we use filter method to check if the type of metadataObj is supported
            if let unwraped = transformed {
                
                // if the found metadata is equal to the QR code metadata
                videoPreviewLayer.frame = (transformed?.bounds)!
                
                // then update the status label's text and set the bounds
                if unwraped.stringValue != nil {
                    print("\nSTRING VALUE: ", unwraped.stringValue!)
                    lblString.text = unwraped.stringValue
                    btnStartStop.setTitle("START", for: .normal)
                    self.performSelector(onMainThread: #selector(stopReading), with: nil, waitUntilDone: false)
                    isReading = false;
                }
            }
        }
    }
    
    @IBAction func startStopClick(_ sender: UIButton) {
        if !isReading {
            if (self.startReading()) {
                btnStartStop.setTitle("STOP", for: .normal)
                lblString.text = "Scanning for QR Code..."
            }
        }
        else {
            stopReading()
            btnStartStop.setTitle("START", for: .normal)
        }
        isReading = !isReading
    }
    
}
