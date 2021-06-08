//
//  WeatherModel.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import UIKit

enum Directions: Double{
    
    case left = -90.0
    case right = 90.0
    
    
}

enum LabelsPosition {
    case inner
    case outterX
    case outterY
}


class NormalWeather: Codable{
    
    var latitude: Double?
    var longitude: Double?
    var timezone: String?
    var currently: Currently?
    var hourly: Hourly?
    var daily: DailyNormal?
    var flags: FlagsNormal?
    var offset: Int?
    
    
}




class TimeMachineWeather: Codable{
    
    var latitude: Double?
    var longitude: Double?
    var timezone: String?
    var currently: Currently?
    var hourly: Hourly?
    var daily: DailyTimeMachine?
    var flags: FlagsTimeMachine?
    var offset: Int?
    
}

struct FlagsNormal: Codable{
    
    
    enum CodingKeys: String, CodingKey {
        
        case meteoalarmlicense = "meteoalarm-license"
        
        case neareststation = "nearest-station"    }
    
    
    var sources: [String]?
    
    var meteoalarmlicense: String?
    
    var neareststation: Double?
    
    var units: String?
    
    
    
}


struct FlagsTimeMachine: Codable{
    
    
    enum CodingKeys: String, CodingKey {
        
        
        case neareststation = "nearest-station"    }
    
    
    var sources: [String]?
    var neareststation: Double?
    var units: String?
    
    
    
}


struct Currently: Codable{
    
    var temperature: Double?
    var humidity: Double?
    let precipProbability: Double?
    let summary: String?
    var icon: String?
    
}

struct Hourly: Codable{
    
    
    var summary : String?
    var icon: String?
    var data: [HourData]?
    
}


struct HourData: Codable{
    
    var time: Int?
    var summary: String?
    var icon: String?
    var precipProbability: Double?
    var temperature: Double?
    var apparentTemperature: Double?
    var precipIntensity: Double?
    var humidity: Double?
    var pressure: Double?
    var windSpeed: Double?
    var windBearing: Int?
    var cloudCover: Double?
    var uvIndex: Int?
    var visibility: Double?
    
    
    func listProperiesLabes()->[String]{
        
        let properties = Mirror(reflecting: self).children
        
        return properties.map{$0.label!}
    }
    
    func listPropertiesValues()->[Any]{
        
        let properties = Mirror(reflecting: self).children
        
        return properties.map{$0.value}
    }
    
    func listProperties()->[String:Any]{
        
        let propertiesLabels = Mirror(reflecting: self).children.map{$0.label!}
        let propertiesValues = Mirror(reflecting: self).children.map{$0.value}
        
        return Dictionary(uniqueKeysWithValues: zip(propertiesLabels, propertiesValues))
    }
    
    func getPropertyValue(filter: String)->Any?{
        
        return Mirror(reflecting: self).children.first{$0.label == filter}?.value
     
    }
    
}



struct DailyNormal: Codable{
    var summary : String?
    var icon: String?
    var data: [DayData]?
    
    
}


struct DailyTimeMachine: Codable{
    var data: [DayData]?
    
    
}

struct DayData: Codable{
    
    var time: Int?
    var summary: String?
    var icon: String?
    var sunriseTime: Int?
    var sunsetTime: Int?
    var precipProbability: Double?
    var temperatureMax: Double?
    var apparentTemperatureMax: Double?
    var humidity: Double?
    var pressure: Double?
    var windSpeed: Double?
    var windBearing: Int?
    var cloudCover: Double?
    var uvIndex: Int?
    var visibility: Double?
    var moonPhase: Double?
    
    
    
}



enum HourDataOption:String{
    
    case time = "time"
    case precipProbability = "precipProbability"
    case temperature = "temperature"
    case apparentTemperature = "apparentTemperature"
    
    case precipIntensity   = "precipIntensity"
    case humidity = "humidity"
    case pressure = "pressure"
    case windSpeed = "windSpeed"
    case windBearing = "windBearing"
    case cloudCover = "cloudCover"
    case uvIndex = "uvIndex"
    case visibility = "visibility"
    

}
















