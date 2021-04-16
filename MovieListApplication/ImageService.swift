//
//  ImageService.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import Foundation
import UIKit

class ImageService {
    
    // Caching the image and checking with the URL to make sure that images dont flicker while paginating
    
static let cache = NSCache<NSString, UIImage>()
    

static func downloadImage (from imageUrl: String!, completion: @escaping (_ image: UIImage?, _ imageUrl: String?) -> ()) {
        
        let url = URLRequest(url: URL(string: imageUrl)!)
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            var downlaoadImage: UIImage?
            
            if let data = data {
                
                downlaoadImage = UIImage(data: data)
        
        }
            
            
            if downlaoadImage != nil {
                
                cache.countLimit = 10 * 1024 * 1024
                
                cache.totalCostLimit = 100
                
                cache.setObject(downlaoadImage!, forKey: imageUrl! as NSString)
                
                
            }
            
            
            DispatchQueue.main.async {
                
                completion(downlaoadImage, imageUrl)
                
            }
            
        
        }
        
        
        dataTask.resume()
        
    }
 
    static func getImage(from imageUrl: String!, completion: @escaping (_ image: UIImage?, _ imageUrl: String?) -> ()) {
        
        
        
        if let imageC = cache.object(forKey: imageUrl! as NSString) {
            
            completion(imageC, imageUrl)
            
        } else {
            
            downloadImage(from: imageUrl, completion: completion)
            
        }
        
    }
    
}
