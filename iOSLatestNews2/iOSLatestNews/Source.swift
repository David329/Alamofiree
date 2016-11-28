//
//  Source.swift
//  iOSLatestNews
//
//  Created by Alumnos on 11/23/16.
//  Copyright © 2016 UPC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Source {
    var id: String?
    var name: String?
    var description: String?
    var url: String?
    var category: String?
    var language: String?
    var country: String?
    var urlsToLogos: [String: String]?
    var sortBysAvailable: [String]?
    
    var urlToSmallLogo: String {
        get {
            return urlsToLogos!["small"]!
        }
    }
    
    var urlToMediumLogo: String {
        get {
            return urlsToLogos!["medium"]!
        }
    }
    
    var urlToLargeLogo: String {
        get {
            return urlsToLogos!["large"]!
        }
    }
    
    static func build(jsonSource: JSON) -> Source {
        var urlsToLogos = [String: String]()
        urlsToLogos["small"] = jsonSource["urlsToLogos"]["small"].stringValue
        urlsToLogos["medium"] = jsonSource["urlsToLogos"]["medium"].stringValue
        urlsToLogos["large"] = jsonSource["urlsToLogos"]["large"].stringValue
        var sortBysAvailable = [String]()
        sortBysAvailable = jsonSource["sortBysAvailable"].arrayValue.map { $0.stringValue }
        let source = Source()
        source.id = jsonSource["id"].stringValue
        source.name = jsonSource["name"].stringValue
        source.description = jsonSource["description"].stringValue
        source.url = jsonSource["url"].stringValue
        source.category = jsonSource["category"].stringValue
        source.language = jsonSource["language"].stringValue
        source.country = jsonSource["country"].stringValue
        source.urlsToLogos = urlsToLogos
        source.sortBysAvailable = sortBysAvailable
        return source
    }
    
    static func build(jsonSources: [JSON]) -> [Source] {
        var sources = [Source]()
        sources = jsonSources.map { Source.build(jsonSource: $0) }
        return sources
    }
}
