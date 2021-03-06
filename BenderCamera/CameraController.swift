//
//  ViewController.swift
//  BenderCamera
//
//  Created by bestK1ng on 20/10/2017.
//  Copyright © 2017 bestK1ng. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class CameraController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIView!
    
    // Timer
    var timer = Timer()
    var indicatorTime = Timer()
    
    // AVFoundation
    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSession()
        startTimerWithTimeInterval(10) // take photo every 10 seconds
        startIndicatorAnimation()
    }

    func startTimerWithTimeInterval(_ timeInterval: Double) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.capturePhoto), userInfo: nil, repeats: true)
    }
    
    func setupSession() {
        
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.photo
        
        let camera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do { input = try AVCaptureDeviceInput(device: camera!) } catch { return }
        
        output = AVCaptureStillImageOutput()
        output?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        guard (session?.canAddInput(input!))! && (session?.canAddOutput(output!))! else { return }
        
        session?.addInput(input!)
        session?.addOutput(output!)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer!.connection?.videoOrientation = .landscapeRight
        
        view.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
    }
    
    @objc func capturePhoto() {
        
        // Set focus
        self.autofocus()
        
        // Capture image
        guard let connection = output?.connection(with: AVMediaType.video) else { return }
        connection.videoOrientation = .portrait
        output?.captureStillImageAsynchronously(from: connection) { (sampleBuffer, error) in
            guard sampleBuffer != nil && error == nil else { return }
            
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
            guard var image = UIImage(data: imageData!) else { return }
            
            image = self.rotate(image: image)
            
            // Show image
            self.imageView.image = image
            
            // Send image
            self.sendImage(image)
        }
    }
    
    func startIndicatorAnimation() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.animateIndicator), userInfo: nil, repeats: true)
    }
    
    @objc func animateIndicator() {
        
        let blinkDuration = 0.3
        UIView.animate(withDuration: blinkDuration, animations: {
            self.indicator.isHidden = !self.indicator.isHidden
        })
    }
    
    func stopIndicatorAnimation() {
        self.view.layer.removeAllAnimations()
    }
    
    // MARK: Server
    
    func sendImage(_ image: UIImage) {
        
        let imageData = UIImageJPEGRepresentation(image, 0.6)!
        let parameters = ["token": "23317bcdde58306bfb3e321fb2803fea",
                          "image": imageData] as [String : Any]
        
        Alamofire.request("http://77.244.216.138:3001/upload", method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).response { (response) in
            print(response)
        }
    }
 
    // MARK: Heplers
    
    func autofocus() {
        
        let thisFocusPoint = self.view.center
        
        let focusX = thisFocusPoint.x / self.view.frame.width
        let focusY = thisFocusPoint.y / self.view.frame.height
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        if (captureDevice!.isFocusModeSupported(.autoFocus) && captureDevice!.isFocusPointOfInterestSupported) {
            do {
                try captureDevice?.lockForConfiguration()
                captureDevice?.focusMode = .autoFocus
                captureDevice?.focusPointOfInterest = CGPoint(x: focusX, y: focusY)
                
                if (captureDevice!.isExposureModeSupported(.autoExpose) && captureDevice!.isExposurePointOfInterestSupported) {
                    captureDevice?.exposureMode = .autoExpose;
                    captureDevice?.exposurePointOfInterest = CGPoint(x: focusX, y: focusY);
                }
                
                captureDevice?.unlockForConfiguration()
                
            } catch {
                print(error)
            }
        }
    }
    
    func rotate(image: UIImage) -> UIImage {
        
        var rotatedImage = UIImage()
        
        if UIDevice.current.orientation == .landscapeRight {
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1, orientation: .down)
        } else if UIDevice.current.orientation == .landscapeLeft {
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1, orientation: .up)
        }
        
        return rotatedImage
    }
}

