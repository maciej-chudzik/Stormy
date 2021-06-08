//
//  PlistReader.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

class PlistReader : NSObject{
    
    
    @objc static let sharedInstance = PlistReader()

    @objc func getValue(nameOfFile: String, nameOfKey: String) -> AnyObject{
        
        let path = Bundle.main.path(forResource: nameOfFile, ofType: "plist")
        let nameOfFile = NSDictionary(contentsOfFile: path!)
        
        return nameOfFile?.object(forKey: nameOfKey) as AnyObject    }
    
    override init(){
        super.init()
    }
    
}
