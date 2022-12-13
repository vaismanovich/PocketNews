//
//  AbsenseImageView.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 06.12.2022.
//

import SwiftUI

struct AbsenseImageView: View {
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .padding()
            .background(.yellow)
            .foregroundColor(.blue)
            .opacity(0.4)
    }
}

struct AbsenseImageView_Previews: PreviewProvider {
    static var previews: some View {
        AbsenseImageView()
    }
}
