//
//  BarcodeScannerView.swift
//  BarcodeScanner
//
//  Created by Peter Visser on 05/04/16.
//  Copyright © 2016 PeeVeeOne. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


internal class BarcodeScannerView : UIView, BarcodeScanner, BarcodeScannerDelegate {
    
    var barcodeScanner = BarcodeScannerImpl()
    var decodeBounds : UIView = UIView()
    
    var delegate : BarcodeScannerDelegate?
    
    required  init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.alpha = 0
        
        barcodeScanner.delegate = self
        
        self.layer.addSublayer(barcodeScanner.previewLayer)
        self.addSubview(decodeBounds)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BarcodeScannerView.onShortTap))
        self.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(BarcodeScannerView.onLongTap))
        longPressGesture.minimumPressDuration = 0.3
        self.addGestureRecognizer(longPressGesture)
    }
    
    private var _registerBarcode = false
    
    func onLongTap(sender: UILongPressGestureRecognizer){
        
        _registerBarcode = (sender.state == UIGestureRecognizerState.Began || sender.state == UIGestureRecognizerState.Changed)
        
    }
    
    func onShortTap(sender: UILongPressGestureRecognizer){
        
        if(barcodeScanner.running || self.alpha < 1 || _registerBarcode){
            return
        }
        
        hideDecodeBounds()
        
        barcodeScanner.start()
        
    }
    
    override   func layoutSubviews() {
        
        barcodeScanner.previewLayer.frame = self.bounds
        barcodeScanner.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
    }
    
    
    private func showDecodeBounds(bounds: CGRect, color: CGColor)
    {
        decodeBounds.layer.borderWidth = 4
        decodeBounds.layer.borderColor = color
        decodeBounds.frame = bounds
        bringSubviewToFront(decodeBounds)
        decodeBounds.hidden = false
        
    }
    
    private func hideDecodeBounds()
    {
        if(!_registerBarcode){
            decodeBounds.hidden = true
        }
    }
    
    func barcodeScannerBarcodeDecoded(barcode : Barcode){
        
        if(_registerBarcode) {
            
            barcodeScanner.stop()
            
            Dispatch.async({
                
                self.showDecodeBounds(barcode.bounds, color: UIColor.redColor().CGColor)
                self.delegate?.barcodeScannerBarcodeDecoded(barcode)
                
            })
            
        } else {
            
            showDecodeBounds(barcode.bounds, color: UIColor.yellowColor().CGColor)
            
            Dispatch.after(0.25, action: {
                self.hideDecodeBounds()
            })
        }
        
        
    }
    
    
    func start(){
        
        barcodeScanner.start()
        
        self.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.alpha = 1
            
        })
    }
    
    func stop() {
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.alpha = 0
            
        })
        
        barcodeScanner.stop()
        
        hideDecodeBounds()
    }
    
    var running : Bool {
        get{
            return barcodeScanner.running
        }
    }
    
    
}