//
//  EntriesListViewModel.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 25.01.2021.
//

import Foundation

class EntriesListViewModel {
    
    var hasError = false
    var errorMessage: String? = nil
    var entries = [EntryViewModel]()
    
    private let client: ProviderProtocol
    private var afterTag: String? = nil
    
    init(withClient client: ProviderProtocol) {
        
        self.client = client
    }
    
    func loadEntries(withCompletion completionHandler: @escaping () -> ()) {
        
        self.client.getTopEntries(after: self.afterTag, limit: 30, completionHandler: { [weak self] responseDictionary in
            
            guard let self = self else {
                
                return
            }
            
            guard let data = responseDictionary["data"] as? [String: AnyObject],
                  let children = data["children"] as? [[String:AnyObject]] else {
                
                self.hasError = true
                self.errorMessage = "Invalid responseDictionary."
                
                return
            }
            
            self.afterTag = data["after"] as? String
            
            let newEntries = children.map { dictionary -> EntryViewModel in
                
                let dataDictionary = dictionary["data"] as? [String: AnyObject] ?? [String: AnyObject]()
                
                let entryModel = EntryModel(withDictionary: dataDictionary)
                let entryViewModel = EntryViewModel(withModel: entryModel)
                
                return entryViewModel
            }
            
            self.entries.append(contentsOf: newEntries)
            
            self.hasError = false
            self.errorMessage = nil
            
            DispatchQueue.main.async() {
                
                completionHandler()
            }
            
        }, errorHandler: { [weak self] message in
            
            guard let self = self else {
                
                return
            }
            
            self.hasError = true
            self.errorMessage = message
            
            DispatchQueue.main.async() {
                
                completionHandler()
            }
        })
    }
}
