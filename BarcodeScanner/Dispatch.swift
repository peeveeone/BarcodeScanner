//
//  Dispatch.swift
//  BarcodeScanner
//
//  Created by Peter Visser on 07/04/16.
//  Copyright © 2016 PeeVeeOne. All rights reserved.
//

import Foundation

internal class Dispatch{
    
   static func after(delay : Double, action: () -> ()){
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            
            action()
            
        }
    }
    
    static func async(action: () -> ()) {
        
        dispatch_async(dispatch_get_main_queue()) { 
            action()
        }
        
    }
    
}