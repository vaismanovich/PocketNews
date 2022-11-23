//
//  News.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 23.11.2022.
//

import Foundation

struct Response: Codable {
    let result: [News]
}

struct News: Identifiable {
    let id:        Int
    let published: Date
    let url:       URL
    let author:    String
    let title:     String
    let subtitle:  String
    var thumbnail: URL?
    var image:     URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case published = "publishedDate"
        case url
        case author = "byline"
        case title
        case subtitle = "abstract"
        case thumbnail
        case image
        case media
    }
}

extension News: Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        lhs.id == rhs.id
    }
}

extension News: Codable {
  
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id           = try container.decode(Int.self, forKey: .id)
        url          = try container.decode(URL.self, forKey: .url)
        author       = try container.decode(String.self, forKey: .author)
        title        = try container.decode(String.self, forKey: .title)
        subtitle     = try container.decode(String.self, forKey: .subtitle)
        
        do {
            image     = try container.decodeIfPresent(URL.self, forKey: .image)
            thumbnail = try container.decodeIfPresent(URL.self, forKey: .thumbnail)
            published = try container.decode(Date.self, forKey: .published)
        } catch {
            let media = try container.decode([Media].self, forKey: .media)
            
            thumbnail = media.first?.mediaMetaData.filter {
                $0.format == News.Media.MediaMetaData.Format.thumbnail.rawValue
            }.first?.url
            
            image = media.first?.mediaMetaData.filter {
                $0.format == News.Media.MediaMetaData.Format.image.rawValue
            }.first?.url
            
            let publishedString = try container.decode(String.self, forKey: .published)
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            published = dateFormatterGet.date(from: publishedString) ?? .now
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(published, forKey: .published)
        try container.encode(url, forKey: .url)
        try container.encode(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(image, forKey: .image)
        
    }
    
}

extension News {
    struct Media: Codable {
        let mediaMetaData: [MediaMetaData]
        
        enum CodingKeys: String, CodingKey {
            case mediaMetaData = "media-metadata"
        }
    }
}

extension News.Media {
    struct MediaMetaData: Codable {
        let url: URL
        let format: String
        
        enum Format: String {
            case thumbnail = "Standard Thumbnail" //need to check spelling
            case image     = "mediumThreeByTwo440"
        }
    }
}
