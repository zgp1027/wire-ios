// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


import XCTest
import ZMCLinkPreview
@testable import Wire

class ArticleViewTests: ZMSnapshotTestCase {
    
    var sut: ArticleView!
    
    override func setUp() {
        super.setUp()
        accentColor = .VividRed
    }
    
    /// MARK - Fixture
    
    func articleWithoutPicture() -> MockTextMessageData {
        let article = Article(originalURLString: "https://www.example.com/article/1", permamentURLString: "https://www.example.com/article/1", offset: 0)
        article.title = "Title with some words in it"
        article.summary = "Summary summary summary summary summary summary summary summary summary summary summary summary summary summary summary"
        
        let textMessageData = MockTextMessageData()
        textMessageData.linkPreview = article
        
        return textMessageData
    }
    
    func articleWithPicture() -> MockTextMessageData {
        let article = Article(originalURLString: "https://www.example.com/article/1", permamentURLString: "https://www.example.com/article/1", offset: 0)
        article.title = "Title with some words in it"
        article.summary = "Summary summary summary summary summary summary summary summary summary summary summary summary summary summary summary"
        
        let textMessageData = MockTextMessageData()
        textMessageData.linkPreview = article
        textMessageData.imageData = UIImageJPEGRepresentation(imageInTestBundleNamed("unsplash_matterhorn.jpg"), 0.9)
        textMessageData.hasImageData = true
        
        return textMessageData
    }
    
    func articleWithLongURL() -> MockTextMessageData {
        let article = Article(originalURLString: "https://www.example.com/verylooooooooooooooooooooooooooooooooooooongpath/article/1/",
                              permamentURLString: "https://www.example.com/veryloooooooooooooooooooooooooooooooooooongpath/article/1/", offset: 0)
        article.title = "Title with some words in it"
        article.summary = "Summary summary summary summary summary summary summary summary summary summary summary summary summary summary summary"
        
        let textMessageData = MockTextMessageData()
        textMessageData.linkPreview = article
        textMessageData.imageData = UIImageJPEGRepresentation(imageInTestBundleNamed("unsplash_matterhorn.jpg"), 0.9)
        textMessageData.hasImageData = true
        
        return textMessageData
    }
    
    func twitterStatusWithoutPicture() -> MockTextMessageData {
        let twitterStatus = TwitterStatus(
            originalURLString: "https://www.example.com/twitter/status/12345",
            permamentURLString: "https://www.example.com/twitter/status/12345/permanent",
            offset: 0
        )
        twitterStatus.author = "John Doe"
        twitterStatus.username = "johndoe"
        twitterStatus.message = "Message message message message message message message message message message message message message message message message message message"
        
        let textMessageData = MockTextMessageData()
        textMessageData.linkPreview = twitterStatus
        
        return textMessageData
    }
    
    /// MARK - Tests
    
    func testArticleViewWithoutPicture() {
        sut = ArticleView(withImagePlaceholder: false)
        sut.translatesAutoresizingMaskIntoConstraints = false
        sut.configure(withTextMessageData: articleWithoutPicture())
        sut.layoutIfNeeded()
        
        verifyInAllPhoneWidths(view: sut)
    }
        
    func testArticleViewWithPicture() {
        sut = ArticleView(withImagePlaceholder: true)
        sut.translatesAutoresizingMaskIntoConstraints = false
        sut.configure(withTextMessageData: articleWithPicture())
        sut.layoutIfNeeded()
        
        verifyInAllPhoneWidths(view: sut)
    }
    
    func testArticleViewWithPictureStillDownloading() {
        
        sut = ArticleView(withImagePlaceholder: true)
        sut.layer.speed = 0 // freeze animations for deterministic tests
        sut.layer.beginTime = 0
        sut.translatesAutoresizingMaskIntoConstraints = false
        let textMessageData = articleWithPicture()
        textMessageData.imageData = .None
        sut.configure(withTextMessageData: textMessageData)
        sut.layoutIfNeeded()
        
        verifyInAllPhoneWidths(view: sut)
    }
    
    func testArticleViewWithTruncatedURL() {
        sut = ArticleView(withImagePlaceholder: true)
        sut.translatesAutoresizingMaskIntoConstraints = false
        sut.configure(withTextMessageData: articleWithLongURL())
        sut.layoutIfNeeded()
        
        verifyInAllPhoneWidths(view: sut)
    }
    
    func testArticleViewWithTwitterStatusWithoutPicture() {
        sut = ArticleView(withImagePlaceholder: false)
        sut.translatesAutoresizingMaskIntoConstraints = false
        sut.configure(withTextMessageData: twitterStatusWithoutPicture())
        sut.layoutIfNeeded()
        
        verifyInAllPhoneWidths(view: sut)
    }
}