//
//  EntryTableViewCell.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 25.01.2021.
//

import UIKit

protocol EntryTableViewCellDelegate {
    
    func presentImage(withURL url: URL)
}

class EntryTableViewCell: UITableViewCell {

    static let cellId = "EntryTableViewCell"
    
    var entry: EntryViewModel? {
        
        didSet {
            
            self.configureForEntry()
        }
    }
    
    var delegate: EntryTableViewCellDelegate?
    
    @IBOutlet private weak var thumbnailButton: UIButton!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBOutlet private weak var timeSpentLabel: UILabel!
    @IBOutlet private weak var entryTitleLabel: UILabel!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.configureViews()
    }
    
    @IBAction func thumbnailButtonTapped(_ sender: AnyObject) {
        
        if let url = self.entry?.url {
            
            self.delegate?.presentImage(withURL: url)
        }
    }
    
    private func configureViews() {
        self.commentsCountLabel.layer.cornerRadius = self.commentsCountLabel.bounds.size.height / 2
    }
    
    private func configureForEntry() {
        
        guard let entry = self.entry else {
            
            return
        }
        
        self.thumbnailButton.setImage(entry.thumbnail, for: [])
        self.authorLabel.text = entry.author
        self.commentsCountLabel.text = entry.commentsCount
        self.timeSpentLabel.text = entry.timeSpent
        self.entryTitleLabel.text = entry.title
        
        entry.loadThumbnail { [weak self] downloadedImage in
            if let image = downloadedImage {
            self?.thumbnailButton.setImage(image, for: [])
        }
    }
}
}
