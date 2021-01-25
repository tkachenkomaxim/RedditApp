//
//  ProviderProtocol.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 24.01.2021.
//

import Foundation

protocol ProviderProtocol {
    
    func getTopEntries(after lastEntry: String?, limit maxCount: Int, completionHandler: @escaping ([String: AnyObject]) -> (), errorHandler: @escaping (_ message: String) -> ())
}
