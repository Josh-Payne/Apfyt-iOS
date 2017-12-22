//
//  ViewController.swift
//  Apfyt
//
//  Created by Josh Payne on 4/9/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import UIKit
import AVFoundation
import ResearchKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var output: AVCaptureVideoDataOutput!
    var h1 = ""
    var counter = 0
    var previous = 0
    var hexInt = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetiFrame960x540
        for device in AVCaptureDevice.devices() {
            if ((device as AnyObject).position == AVCaptureDevicePosition.back) {
                self.device = device as! AVCaptureDevice
            }
        }
        if (self.device == nil) {
            print("no device")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: self.device)
            self.session.addInput(input)
        } catch {
            print("no device input")
            return
        }
        self.output = AVCaptureVideoDataOutput()
        self.output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA) ]
        let queue: DispatchQueue = DispatchQueue(label: "videocapturequeue", attributes: [])
        self.output.setSampleBufferDelegate(self, queue: queue)
        self.output.alwaysDiscardsLateVideoFrames = true
        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
        } else {
            print("could not add a session output")
            return
        }
        do {
            try self.device.lockForConfiguration();
            self.device.activeVideoMinFrameDuration = CMTimeMake(1, 30) // 30 fps
            self.device.unlockForConfiguration()
        } catch {
            print("could not configure a device")
            return
        }
        self.session.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        // Convert a captured image buffer to UIImage.
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("could not get a pixel buffer")
            return
        }
        let capturedImage: UIImage
        do {
            CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
            defer {
                CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
            }
            let address = CVPixelBufferGetBaseAddressOfPlane(buffer, 0)
            let bytes = CVPixelBufferGetBytesPerRow(buffer)
            let width = CVPixelBufferGetWidth(buffer)
            let height = CVPixelBufferGetHeight(buffer)
            let color = CGColorSpaceCreateDeviceRGB()
            let bits = 8
            let info = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
            guard let context = CGContext(data: address, width: width, height: height, bitsPerComponent: bits, bytesPerRow: bytes, space: color, bitmapInfo: info) else {
                print("could not create an CGContext")
                return
            }
            guard let image = context.makeImage() else {
                print("could not create an CGImage")
                return
            }
            capturedImage = UIImage(cgImage: image, scale: 1.0, orientation: UIImageOrientation.right)
        }
        
        // This is a filtering sample.
        
            hexInt = OpenCV.decode(capturedImage)
        
        //let image = OpenCV2.cvtColorBGR2GRAY(capturedImage)
                // Show the result.
        DispatchQueue.main.async(execute: {
            if (self.hexInt > 0) {
                
                if (self.hexInt != self.previous) {
                    self.counter = 0;
                    //print("")
                } else {
                    self.counter += 1
                    //print(self.hexInt)
                }
                //let image = OpenCV2.cvtColorBGR2GRAY(capturedImage)
                //self.imageView.image = image;
                self.previous = self.hexInt;
                if (self.counter == 7 && self.hexInt != 0) { //Quality control
                    self.session.stopRunning()
                    self.h1 = String(self.hexInt, radix: 16)
                    self.segue()
                }
            } else {
                self.imageView.image = capturedImage
                self.counter = 0;
            }
        })
    }
    
    func segue() {
        self.performSegue(withIdentifier: "segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue"){
            let destinationView : SurveyViewController = segue.destination as! SurveyViewController
            if (self.hexInt != 0) {
            destinationView.colorLabelText = h1
            } else {
                destinationView.colorLabelText = "Inaccurate read!"
            }
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


