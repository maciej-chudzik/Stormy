//
//  UnitsConverter.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import UIKit

class UnitsConverter {
    
    
    static func greatesCommonDivisorFaster(a: Int, b: Int) ->Int{
        
        
        if b == 0{
            return a}
        return greatesCommonDivisorFaster(a: b,b: a % b)
        
    }

    static func degreesToCGFloatRadians(_ number: Double) -> CGFloat {
        return CGFloat(number * .pi / 180)
    }
    
    static func farenheitToCelcius(temperature: Double) -> Double{
        
        return 5/9 * (temperature - 32)
        
    }

    static func hoursMinutesStringFromUnixTime(_ unixTime: Double) -> String{
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: unixTime)
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date as Date)
    }
    
    
    static func dayStringFromUnixTime(_ unixTime: Double, countryCode: String) -> String{
        let dateFormatter = DateFormatter()
        
        
        let date = Date(timeIntervalSince1970: unixTime)
        
        dateFormatter.locale = Locale(identifier: "\(countryCode.lowercased())" + "_" + "\(countryCode.lowercased())")
        dateFormatter.dateFormat = "EEEE"
        
        
        return dateFormatter.string(from: date as Date)
    }
    
    static func dayMonthStringFromUnixTime(_ unixTime: Double, countryCode: String) -> String{
        let dateFormatter = DateFormatter()
        
        let date = Date(timeIntervalSince1970: unixTime)
        
        dateFormatter.locale = Locale(identifier: "\(countryCode.lowercased())" + "_" + "\(countryCode.lowercased())")
        dateFormatter.dateFormat = "d.MM"
        
        
        return dateFormatter.string(from: date as Date)
    }
    
    static func hourStringFromUnixTime(_ unixTime: Double, countryCode: String) -> String{
        let dateFormatter = DateFormatter()
        
        let date = Date(timeIntervalSince1970: unixTime)
        
        dateFormatter.locale = Locale(identifier: "\(countryCode.lowercased())" + "_" + "\(countryCode.lowercased())")
        dateFormatter.dateFormat = "HH"
        
        
        return dateFormatter.string(from: date as Date)
    }
    
    
    
    
    static func hourStringFromUnixTime(_ unixTime: Double) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        let date = Date(timeIntervalSince1970: unixTime)
        dateFormatter.dateFormat = "HH"
        
        return dateFormatter.string(from: date as Date)
    }
    
    static func mPerSecToKmPerSec(speed: Double) -> Double{
        
        return speed * 3.6
        
    }
    
    enum UnitSource{
        
        case temperature
        case windSpeed
        case atmPressure
        case visibility
        
        
    }
    
    static func determineUnitType(source: UnitSource) -> String{
        
        switch source {
        case .temperature:
            
            if Locale.current.usesMetricSystem{ return "C"} else {return "F"}
            
        case .windSpeed:
            
            if Locale.current.usesMetricSystem{ return "m/s"} else {return "mph"}
        
        case .atmPressure:
            
            if Locale.current.usesMetricSystem{ return "hPa"} else {return "mbar"}
    
        case .visibility:
            
            if Locale.current.usesMetricSystem{ return "km"} else {return "mi"}
        }
    
    }
    
    static func determineUnitSystem() -> String{
        
        if Locale.current.usesMetricSystem{ return "si"} else {return "us"}
    }
}
