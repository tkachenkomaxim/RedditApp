//
//  RedditProvider.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 24.01.2021.
//

import Foundation

class RedditProvider: ProviderProtocol {
    
    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    func getTopEntries(after lastEntry: String?, limit maxCount: Int = 30, completionHandler: @escaping ([String : AnyObject]) -> (), errorHandler: @escaping (String) -> ()) {
        
        var requestURLString = "https://www.reddit.com/top.json?limit=\(maxCount)"
        
        if let lastEntry = lastEntry {
            
            requestURLString.append("&after=\(lastEntry)")
        }
        
        guard let requestURL = URL(string: requestURLString) else {
            
            errorHandler("An error occurred formatting the fetch URL: \(requestURLString)")
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        self.download(request: request, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    private func download(request: URLRequest, completionHandler:@escaping ([String: AnyObject]) -> (), errorHandler: @escaping (_ message: String) -> ()) {
        
        let dataTask = defaultSession.dataTask(with: request) { (data, response, error) in
            
            guard let _ = response else {
                
                errorHandler("Something went wrong. Please check your internet connection.")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                errorHandler("Invalid server response type.")
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard statusCode == 200 else {
                
                errorHandler("Invalid status code: \(statusCode)")
                return
            }
            
            guard let data = data else {
                
                errorHandler("Response Data is empty.")
                return
            }
            
            do {
                
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] else {
                    
                    errorHandler("An error occurrred when parsing the response.")
                    return
                }
                
                completionHandler(dictionary)
            } catch {
                
                errorHandler("An error occurrred when parsing the response.")
            }
        }
        dataTask.resume()
    }
}
