//
//  Date+Formatter.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 25.01.2021.
//

import Foundation

extension Date {
    
    func spentTime(sinceDate presentDate: Date = Date()) -> String {
        
        let secondsAgo = Int(presentDate.timeIntervalSince(self))
        
        if secondsAgo == 0 {
            
            return "Now"
            
        } else if secondsAgo == 1 {
            
            return "A second ago"
            
        } else if secondsAgo < 60 {
            
            return "\(secondsAgo) seconds ago"
            
        } else if secondsAgo < 2 * 60 {
            
            return "A minute ago"
            
        } else if secondsAgo < 60 * 60 {
            
            return "\(secondsAgo / 60) minutes ago"
            
        } else if secondsAgo < 2 * 60 * 60 {
            
            return "An hour ago"
            
        } else if secondsAgo < 24 * 60 * 60 {
            
            return "\(secondsAgo / (60 * 60)) hours ago"
            
        } else if secondsAgo < 2 * 24 * 60 * 60 {
            
            return "A day ago"
            
        } else if secondsAgo < 6 * 24 * 60 * 60 {
            
            return "\(secondsAgo / (24 * 60 * 60)) days ago"
            
        } else {
            
            return "A long time ago"
        }
    }
}
