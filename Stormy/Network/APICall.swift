//
//  APICall.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation

final class APICall<T> {
    
    let method: Method
    let query_parameters: [URLQueryItem]?
    let coordinates: (latitude: Double, longitude: Double)
    let time: Int?
    let decode: (Data) throws  -> T
    
    init(method: Method = .get, query_parameters: [URLQueryItem]? = nil, coordinates: (latitude: Double, longitude: Double), time: Int?=nil, decode: @escaping (Data) throws -> T) {
        
        self.method = method
        self.query_parameters = query_parameters
        self.coordinates = coordinates
        self.time = time
        self.decode = decode
    }
    
}
extension APICall where T: Decodable {
    convenience init(method: Method = .get, query_parameters: [URLQueryItem]? = nil, coordinates: (latitude: Double, longitude: Double), time: Int?=nil) {
        self.init(method: method, query_parameters: query_parameters,coordinates: coordinates, time: time, decode: { data in
            
            try JSONDecoder().decode(T.self, from: data)
            
            
        })
    }
}

extension APICall where T == Void {
    convenience init(method: Method = .get, query_parameters: [URLQueryItem]? = nil, coordinates: (latitude: Double, longitude: Double), time: Int?=nil) {
        self.init(method: method, query_parameters: query_parameters,coordinates: coordinates, time: time, decode: { _ in () }
        )
    }
}
