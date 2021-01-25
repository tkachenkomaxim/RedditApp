//
//  EntryViewModel.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 25.01.2021.
//

import Foundation
import UIKit

class EntryViewModel {
    
    var hasError = false
    var errorMessage: String? = nil

    let title: String
    let author: String
    
    var timeSpent: String {
        
        get {
            guard let creation = self.creation else {
                
                return "-"
            }
            
            return creation.spentTime()
        }
    }
    
    var thumbnail: UIImage
    let commentsCount: String
    let url: URL?
    
    private let creation: Date?
    private let thumbnailURL: URL?
    private var thumbnailFetched = false

    init(withModel model: EntryModel) {
        
        func markAsMissingRequiredField() {
            
            self.hasError = true
            self.errorMessage = "Missing required field"
        }

        self.title = model.title ?? "Untitled"
        self.author = model.author ?? "Anonymous"
        self.thumbnailURL = model.thumbnailURL
        self.thumbnail = UIImage(named: "linq_placeholder") ?? UIImage()
        self.commentsCount = " \(model.commentsCount ?? 0) "
        self.creation = model.creationTime
        self.url = model.url

        if model.title == nil ||
            model.author == nil ||
            model.creationTime == nil ||
            model.commentsCount == nil {
            
            markAsMissingRequiredField()
        }
    }
    
    func loadThumbnail(withCompletion completion: @escaping (UIImage?) -> ()) {

        guard let thumbnailURL = self.thumbnailURL, self.thumbnailFetched == false else {
            
            return
        }
        
        let downloadThumbnailTask = URLSession.shared.downloadTask(with: thumbnailURL) { [weak self] (url, urlResponse, error) in

            guard let self = self,
                let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                
                return
            }

            self.thumbnail = image
            self.thumbnailFetched = true
            
            DispatchQueue.main.async {
                
                completion(self.thumbnail)
            }
        }
            
        downloadThumbnailTask.resume()
    }
}
