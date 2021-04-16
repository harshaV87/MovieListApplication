//
//  URLDependency.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import Foundation

// Protocols - URLsession task

protocol URLSessionDataTaskProtocol {
    
    func resume()
}



protocol URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

// Extension - URLsession task 

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
    
}

extension URLSession: URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol   {
    
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}
