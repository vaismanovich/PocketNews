//
//  NewsListCellView.swift
//  PocketNews
//
//  Created by Мария Шувалова on 24.12.2022.
//

import SwiftUI

struct NewsListCellView: View {
    let news: News
    
    var body: some View {
        HStack(alignment: .top) {
               CacheImageView(url: news.thumbnail)
                .frame(width: 75, height: 75)
        
            VStack(alignment: .leading) {
                Text(news.published, style: .date)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Text(news.title)
                    .foregroundColor(.primary)
                    .font(.body)
                    .lineLimit(2)
                
                Text(news.author)
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            .lineLimit(1)
        }
    }
}

struct NewsListCellView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListCellView(news: .example1)
    }
}
