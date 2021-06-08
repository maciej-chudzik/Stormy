//
//  Requests.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

struct APIWeatherRequests{
    
    static func getNormalForcast(query_parameters: [URLQueryItem], coordinates: (latitude: Double, longitude: Double)) -> APICall<NormalWeather> {
        return APICall(method: .get, query_parameters: query_parameters, coordinates: coordinates)
    }
    
    static func getTimeMachineForcast(query_parameters: [URLQueryItem], coordinates: (latitude: Double, longitude: Double), time: Int) -> APICall<TimeMachineWeather> {
        return APICall(method: .get, query_parameters: query_parameters, coordinates: coordinates, time: time)
    }

}
