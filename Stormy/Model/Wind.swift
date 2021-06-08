//
//  Wind.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

struct Wind{
    
    static func determineWindDirection(windBearing:Int) -> String{
        
        if (0...5).contains(windBearing) || (355...360).contains(windBearing){
            return "north"
        }else if (6...85).contains(windBearing){
            return "north east"
        }else if (86...95).contains(windBearing){
            return "east"
        }else if (96...175).contains(windBearing){
            return "south east"
        }else if (176...185).contains(windBearing){
            return "south"
        }else if (186...265).contains(windBearing){
            return "south west"
        }else if (266...275).contains(windBearing){
            return "west"
        }else if (276...354).contains(windBearing){
            return "north west"
        }
        
        return ""
    }
}
