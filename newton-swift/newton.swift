//
//  newton.swift
//  newton-swift
//
//  Created by Tyler Walker on 8/3/17.
//  Copyright © 2017 Tyler Walker. All rights reserved.
//

import Foundation

typealias ServiceResponse = ([String: Any], Error?) -> Void
typealias DictCallback = ([String: Any]) -> Void
typealias Endpoint = (String, @escaping DictCallback) -> Void

class NewtonAPI: NSObject {
    static let sharedInstance = NewtonAPI()
    
    fileprivate let ENDPOINTS = ["simplify", "factor", "derive", "integrate", "zeroes",
                                 "tangent", "area", "cos", "sin", "tan", "arccos",
                                 "arcsin", "arctan", "abs", "log"]
    
    var core: [String: Endpoint] = [:]
    
    override init() {
        super.init()
        
        for endpoint in ENDPOINTS {
            self.core[endpoint] = createEndpoint(forOperation: endpoint)
        }
    }
    
    
    fileprivate let base = "https://newton.now.sh/"
    
    fileprivate func sendRequest(operation: String, expression: String, onCompletion: @escaping DictCallback) {
        let route = makeRouteWithEncodedExpression(forOperation: operation, expression: expression)
        
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            guard err == nil else {
                print(err!)
                return
            }
            onCompletion(json as [String: Any])
        })
    }
    
    fileprivate func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: URL(string: path)!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            guard let data = data else {
                print("Data is empty")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                onCompletion(json!, error)
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        })
        task.resume()
    }
    
    
    fileprivate func createEndpoint(forOperation op: String) -> (String, @escaping DictCallback) -> Void {
        return { exp, cb in
            self.sendRequest(operation: op, expression: exp, onCompletion: cb)
        }
    }
    
    fileprivate func makeRouteWithEncodedExpression(forOperation operation: String, expression: String) -> String {
        let urlEncodedExpression = expression.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let route = base + operation + urlEncodedExpression!
        return route
    }
    
    open func newton(_ operation: String,_ expression: String,_ onCompletion: @escaping DictCallback) {
        
        if let endpoint = self.core[operation] {
            return endpoint(expression, onCompletion)
        } else {
            return onCompletion(["error": "NewtonMath does not support the endpoint \(operation)"])
        }
    }
    
    
}
