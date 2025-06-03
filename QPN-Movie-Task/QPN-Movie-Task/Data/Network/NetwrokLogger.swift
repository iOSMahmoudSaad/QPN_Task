//
//  NetwrokLogger.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

final class NetworkLogger {
    
    static func logRequest(_ request: URLRequest) {
           #if DEBUG
           print("🌐 Network Request:")
           print("URL: \(request.url?.absoluteString ?? "Unknown")")
           print("Method: \(request.httpMethod ?? "Unknown")")
           
           if let headers = request.allHTTPHeaderFields {
               print("Headers: \(headers)")
           }
           
           if let httpBody = request.httpBody {
               print("Request Body Size: \(httpBody.count) bytes")
               if let bodyString = String(data: httpBody, encoding: .utf8) {
                   print("Request Body: \(bodyString)")
               } else {
                   print("Request Body: [Binary Data]")
               }
           }
           
           print("--- End Request ---\n")
           #endif
       }
    
    static func logResponse(_ response: URLResponse?, data: Data?) {
        #if DEBUG
        print("📡 Network Response:")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let data = data {
            print("Data Size: \(data.count) bytes")
            
            if data.count > 0 {
                if let jsonString = serializeData(data) {
                    print("Response Body: \(jsonString)")
                } else if let bodyString = String(data: data, encoding: .utf8) {
                    print("Response Body: \(bodyString)")
                } else {
                    print("Response Body: [Binary Data]")
                }
            }
        }
        
        print("--- End Response ---\n")
        #endif
    }
    
    private static func serializeData(_ data: Data) -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(data: prettyData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}


