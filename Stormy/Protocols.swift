//
//  Protocols.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import UIKit


protocol Fullscreenable: AnyObject{
    
    var fullscreened: Bool{get set}

}

protocol Fadable: AnyObject{
    
    var isFaded: Bool{get set}
    
}

protocol RollableUp: AnyObject{
    
    var zeroHeightConstraint: NSLayoutConstraint? {get set}
    
}




