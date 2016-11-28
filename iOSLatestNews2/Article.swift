//
//  Article.swift
//  iOSLatestNews
//
//  Created by Alumnos on 11/23/16.
//  Copyright © 2016 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var source: Source?
    
    static func build(jsonArticle: JSON) -> Article {
        let article = Article()
        article.author = jsonArticle["author"].stringValue
        article.title = jsonArticle["title"].stringValue
        article.description = jsonArticle["description"].stringValue
        article.url = jsonArticle["url"].stringValue
        article.urlToImage = jsonArticle["urlToImage"].stringValue
        article.publishedAt = jsonArticle["publishedAt"].stringValue
        return article
    }
    
    static func build(jsonArticles: [JSON]) -> [Article] {
        var articles = [Article]()
        articles = jsonArticles.map { Article.build(jsonArticle: $0 as JSON) }
        return articles
    }
}
