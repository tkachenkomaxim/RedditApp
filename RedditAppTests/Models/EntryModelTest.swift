//
//  EntryModelTest.swift
//  RedditAppTests
//
//  Created by Maxim Tkachenko on 25.01.2021.
//

import XCTest
@testable import RedditApp

class EntryModelTest: XCTestCase {


    func testInit()  {
        let title = "TEST_TITLE"
        let author = "TEST_AUTHOR"
        let creation = NSDate()
        let thumbnailURL = URL(string: "http://site.com/thumb.jpg")!
        let commentsCount = 200
        
        let dictionary: [String: AnyObject] = [
            "title": title as AnyObject,
            "author": author as AnyObject,
            "created_utc": creation.timeIntervalSince1970 as AnyObject,
            "thumbnail": thumbnailURL.absoluteString as AnyObject,
            "num_comments": commentsCount as AnyObject
        ]
        
        let entryModel = EntryModel(withDictionary: dictionary)
        
        XCTAssertEqual(entryModel.title, title)
        XCTAssertEqual(entryModel.author, author)
        XCTAssertEqual(entryModel.creationTime?.timeIntervalSince1970, creation.timeIntervalSince1970)
        XCTAssertEqual(entryModel.thumbnailURL, thumbnailURL)
        XCTAssertEqual(entryModel.commentsCount, commentsCount)
    }

    func testInitWithNils() {
        let dictionary = [String: AnyObject]()
        let entryModel = EntryModel(withDictionary: dictionary)
        
        XCTAssertNil(entryModel.title)
        XCTAssertNil(entryModel.author)
        XCTAssertNil(entryModel.creationTime)
        XCTAssertNil(entryModel.thumbnailURL)
        XCTAssertNil(entryModel.commentsCount)
    }

}
