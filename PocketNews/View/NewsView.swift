//
//  NewsView.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 22.12.2022.
//

import SwiftUI

struct NewsView: View {
    let news: News
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(news.title)
                    .font(.largeTitle)
                
                HStack {
                    Text(news.author)
                    Spacer()
                    Text(news.published, style: .date)
                }
                .foregroundColor(.black)
                
                CacheImageView(url: news.image)
                
                Text(news.subtitle)
                    .font(.title3)
            }
            .padding(.horizontal)
            
            Link("Read full version on NYTimes", destination: news.url)
                .padding(.vertical)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(news: .example1)
    }
}
