//
//  ViewController.swift
//  BarcodeScanner
//
//  Created by Peter Visser on 07/04/16.
//  Copyright © 2016 PeeVeeOne. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, BarcodeScannerDelegate {
    
    
    @IBOutlet var scanner: BarcodeScannerView!
    @IBOutlet var barcodeType: UILabel!
    @IBOutlet var barcodeContents: UILabel!
    @IBOutlet var captureButton: UIButton!
    
    private var toggleStarted : Bool = false
    
    @IBAction func toggleCapture(sender: AnyObject) {
        
        setBarcodeResult("", content: "")
        
        toggleStarted = !toggleStarted
        
        if(toggleStarted){
            scanner.start()
            
            
        } else {
            scanner.stop()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scanner.delegate = self
        
        setBarcodeResult("", content: "")
       
    }
    
 
    
    func  barcodeScanner(decoded barcode : Barcode){
        
        setBarcodeResult(barcode.type, content: barcode.value)
        
    }
    
    func setBarcodeResult(type : String, content : String){
        
        self.barcodeType.text = type;
        self.barcodeContents.text = content;
        
    }
    
}


