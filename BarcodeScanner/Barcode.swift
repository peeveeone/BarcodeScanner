//
//  Barcode.swift
//  BarcodeScanner
//
//  Created by Peter Visser on 05/04/16.
//  Copyright © 2016 PeeVeeOne. All rights reserved.
//

import Foundation
import UIKit

public struct Barcode{
    
    public private (set) var type : String
    public private (set) var value : String
    public private (set) var bounds : CGRect
    
    init(type : String, value : String, bounds : CGRect){
        
        self.type = type
        self.value = value
        self.bounds = bounds
        
    }
    
}

