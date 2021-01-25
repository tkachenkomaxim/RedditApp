//
//  EntryModel.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 24.01.2021.
//
import Foundation

struct EntryModel {

    let title: String?
    let author: String?
    let creationTime: Date?
    let thumbnailURL: URL?
    let commentsCount: Int?
    let url: URL?
    
    init(withDictionary dictionary: [String: AnyObject]) {
       
        self.title = dictionary["title"] as? String
        self.author = dictionary["author"] as? String
        self.creationTime =  EntryModel.dateFromDictionarydictionary(dictionary: dictionary, withAttributeName: "created_utc")
        self.thumbnailURL = EntryModel.urlFromDictionary(dictionary: dictionary, withAttributeName: "thumbnail")
        self.commentsCount = dictionary["num_comments"] as? Int
        self.url = EntryModel.urlFromDictionary(dictionary: dictionary, withAttributeName: "url")
    }
}
    
extension EntryModel {
    
     private static func urlFromDictionary(dictionary: [String: AnyObject], withAttributeName attribute: String) -> URL? {
        
        guard let rawURL = dictionary[attribute] as? String else {
            
            return nil
        }
        
        return URL(string: rawURL)
    }

     private static func dateFromDictionarydictionary(dictionary: [String: AnyObject],withAttributeName attribute: String) -> Date? {
        
        guard let rawDate = dictionary[attribute] as? Double else {
            
            return nil
        }
        
        return Date(timeIntervalSince1970: rawDate)
    }
}

