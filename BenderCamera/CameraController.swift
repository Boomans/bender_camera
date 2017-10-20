//
//  ViewController.swift
//  BenderCamera
//
//  Created by bestK1ng on 20/10/2017.
//  Copyright © 2017 bestK1ng. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {

    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var output: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ///
        //capturePhoto()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func setupSession() {
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.photo
        
        let camera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do { input = try AVCaptureDeviceInput(device: camera!) } catch { return }
        
        output = AVCapturePhotoOutput()
        
        guard (session?.canAddInput(input!))! && (session?.canAddOutput(output!))! else { return }
        
        session?.addInput(input!)
        session?.addOutput(output!)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer!.connection?.videoOrientation = .portrait
        
        view.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
    }
    */
    
    /*
    func capturePhoto() {
        guard let connection = output?.connection(with: AVMediaType.video) else { return }
        connection.videoOrientation = .portrait
        
        output?.capturePhoto(with: AVCapturePhotoSettings(), delegate: <#T##AVCapturePhotoCaptureDelegate#>)
        
        output?.captureStillImageAsynchronously(from: connection) { (sampleBuffer, error) in
            guard sampleBuffer != nil && error == nil else { return }
            
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
            guard let image = UIImage(data: imageData!) else { return }
            
            // Do stuff with image
            
        }
    }
    */
}

