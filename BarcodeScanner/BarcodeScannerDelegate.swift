//
//  BarcodeScannerDelegate.swift
//  BarcodeScanner
//
//  Created by Peter Visser on 05/04/16.
//  Copyright © 2016 PeeVeeOne. All rights reserved.
//

import Foundation
import UIKit

protocol BarcodeScannerDelegate {
    
    func barcodeScannerBarcodeDecoded(barcode : Barcode)
}



