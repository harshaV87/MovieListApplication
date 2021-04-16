//
//  DataAPI.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import Foundation
import UIKit

class DataAPI {
   
   enum APIResponseError: String, Error {
       
       case network = "Problem with the network"
       case parsing = "Problem with the data parsing"
       
   }
   
   // Property for data retrieval
    
   private var session: URLSessionProtocol
   
   
   init(withSession session: URLSessionProtocol = URLSession.shared) {
       self.session = session
   }
   
   
   func getDataDetail<T : Decodable>(url: String, typeO: T.Type ,completion: @escaping (_ result: Result<T, Error>, _ responseToken: Int) -> Void) {
       
       
       guard let inputURL = URL(string: url) else {return}
       
       
       let dataTask = session.dataTask(with:inputURL) { (data, urlResponse, error) in
        
       do{
         // Check if any error occured.
         if let error = error {
           throw error
         }

         // Check response code.
         guard let httpResponse = urlResponse as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
           
           let failedStatusCode = urlResponse as? HTTPURLResponse
           
           guard let statusFailedCode = failedStatusCode?.statusCode else {return}
           
           completion(Result.failure(APIResponseError.network), statusFailedCode)
           
           return
         }
        
         // Parse data
           if let responseData = data, let object = try? JSONDecoder().decode(T.self , from: responseData) {
               
               let okStatusCode = urlResponse as? HTTPURLResponse
               
               guard let statusOkCode = okStatusCode?.statusCode else {return}
               
               completion(Result.success(object), statusOkCode)
               
         } else {
           
           throw APIResponseError.parsing
           
         }
        
       } catch {
           
           let okStatusCodeFailed = urlResponse as? HTTPURLResponse
           
           guard let statusOkCode = okStatusCodeFailed?.statusCode else {return}
           
           completion(Result.failure(error), statusOkCode)
       }
     }

     dataTask.resume()
   }
   
}
