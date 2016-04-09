//
//  BarcodeScanner.swift
//  BarcodeScanner
//
//  Created by Peter Visser on 05/04/16.
//  Copyright © 2016 PeeVeeOne. All rights reserved.
//

import Foundation
import AVFoundation

protocol BarcodeScanner {
    
    func start()
    func stop()
    var running : Bool {get}
    var delegate : BarcodeScannerDelegate? {get set}
    
}

class BarcodeScannerImpl : NSObject, BarcodeScanner, AVCaptureMetadataOutputObjectsDelegate  {
    
     var delegate : BarcodeScannerDelegate?
    
     var previewLayer : AVCaptureVideoPreviewLayer {get {
        return _previewLayer}
        }
    
    private let _metaDataOutput = AVCaptureMetadataOutput()
    private let _session = AVCaptureSession()
    private var _previewLayer :AVCaptureVideoPreviewLayer! = nil
    private var _captureDevice : AVCaptureDevice! = nil
  
 

    override convenience init() {
        
        let supportedBarcodeTypes =
            [
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeAztecCode,
                AVMetadataObjectTypeQRCode
        ]

        
        self.init(supportedBarcodeTypes: supportedBarcodeTypes)
    }
    
    init(supportedBarcodeTypes : [String]) {
        
        super.init()
        
        _captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
               
        if let deviceInput = try? AVCaptureDeviceInput(device: _captureDevice){
            
            _session.addInput(deviceInput)
            
        } else {
            
            // Handle in some way, notify user?
            
            return
        }
        
        _metaDataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        _session.addOutput(_metaDataOutput)
        
        _metaDataOutput.metadataObjectTypes = supportedBarcodeTypes
        
        _previewLayer = AVCaptureVideoPreviewLayer(session: _session)
    }
    
    
     func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        let metaData =  metadataObjects.first
        
        if let barcode = metaData as? AVMetadataMachineReadableCodeObject {
            
            let decodeBounds = previewLayer.transformedMetadataObjectForMetadataObject(barcode).bounds
            
            delegate?.barcodeScanner(decoded: Barcode(type: barcode.type, value: barcode.stringValue, bounds: decodeBounds))
        }
    }

    
     func start() {
        
        if(!_session.running){
            _session.startRunning()
            
        }

    }
    
     func stop() {
        
        if(_session.running) {
            _session.stopRunning()
        }
        
    }
    
    var running : Bool {
        get{
            return _session.running
        }
    }
    
}



