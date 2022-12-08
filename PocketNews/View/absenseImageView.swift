//
//  absenseImageView.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 06.12.2022.
//

import SwiftUI

struct absenseImageView: View {
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

struct absenseImageView_Previews: PreviewProvider {
    static var previews: some View {
        absenseImageView()
    }
}
