//
//  CacheImageView.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 14.12.2022.
//

import SwiftUI

struct CacheImageView: View {
    
    @StateObject private var controller: CacheImageController
    
    init(url: URL?) {
        self._controller = .init( wrappedValue: CacheImageController(url: url))
    }
    
    
    var body: some View {
        Group {
            switch controller.state {
            case .failed, .none: AbsenseImageView()
            case .loading: ProgressView()
            case .success: successImageView
            
            }
        }
        .onAppear(perform: controller.fetch)
    }
    
    @ViewBuilder
    var successImageView: some View {
        if let uiImage = controller.uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            AbsenseImageView()
        }
    }
}

struct CacheImageView_Previews: PreviewProvider {
    static var previews: some View {
        CacheImageView(url: TestData.imageURL)
    }
}

struct TestData {
    static let imageURL = URL(string: "https://static01.nyt.com/images/2021/10/21/opinion/21bruni-newsletter-1/21bruni-newsletter-1-mediumThreeByTwo440-v2.jpg")
}
