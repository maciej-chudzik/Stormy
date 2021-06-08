//
//  APIClient.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//


import Foundation

class APIClient {
    
    
    private let session: URLSession
    private var urlComponents: URLComponents
    
    init() {
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
        self.urlComponents = URLComponents()
        urlComponents.host = "api.darksky.net"
        urlComponents.path = "/forecast/\(PlistReader.sharedInstance.getValue(nameOfFile: "APIkeys", nameOfKey: "forecastAPIKey"))/"
        urlComponents.scheme = "https"
        urlComponents.queryItems = [URLQueryItem]()
        
        
    }
    
    
    
    private func httpMethod(from method: Method) -> String {
        
        switch method {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }
    
    
    func request<T>(apicall: APICall<T>, completion: @escaping (T)-> ()){
        
        
        urlComponents.path += "\(apicall.coordinates.latitude),\(apicall.coordinates.longitude)"
        
        if let newQueryItem = apicall.query_parameters{
            urlComponents.queryItems?.append(contentsOf: newQueryItem)
        }
        
        if let time = apicall.time{
            urlComponents.path += ",\(time)"
        }
        
       
        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = self.httpMethod(from: apicall.method)
        
        let dataTask = session.dataTask(with: request) {
            
            (data, response, error) in
            
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    
                    do{
                        let object =  try apicall.decode(data!)
                        
                        completion(object)
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                    
                default:
                    print(" HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
        }
        
        dataTask.resume()
    }
}



enum Method {
    case get, post, put, patch, delete
}

