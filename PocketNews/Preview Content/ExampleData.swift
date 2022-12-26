//
//  ExampleData.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 22.12.2022.
//

import Foundation


extension News {
    static let example1 = News.init(
        id: 100000008023147,
        url: URL(string:  "https://www.nytimes.com/2021/10/15/opinion/covid-vaccines-unvaccinated.html")!,
        published: .now,
        author: "By Zeynep Tufekci",
        title: "The Unvaccinated May Not Be Who You Think",
        subtitle: "Science can find a cure for our diseases, but not for our societal ills.",
        thumbnail: News.Media.MediaMetaData.example1.url,
        image: News.Media.MediaMetaData.example2.url
    )
}

extension News.Media {
    static let example1 = News.Media.init(
        mediaMetaData: [.example1, .example2]
    )
}

extension News.Media.MediaMetaData {
    static let example1 = News.Media.MediaMetaData.init(
        url: URL(string: "https://static01.nyt.com/images/2021/10/16/reader-center/15tufekci_3/15tufekci_3-thumbStandard-v2.jpg")!,
        format: "Standard Thumbnail"
    )
    
    static let example2 = News.Media.MediaMetaData.init(
        url: URL(string: "https://static01.nyt.com/images/2021/10/24/us/24tennessee-statues-top-sub/merlin_196717074_f3ef32a1-2442-4b63-86dd-b7f1a5a749c8-mediumThreeByTwo440.jpg")!,
        format: "mediumThreeByTwo440"
    )
}
