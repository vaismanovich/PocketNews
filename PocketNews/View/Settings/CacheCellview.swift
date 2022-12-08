//
//  CacheCellview.swift
//  PocketNews
//
//  Created by Мария Шувалова on 08.12.2022.
//

import SwiftUI

struct CacheCellview: View {
    let title: String
    let size:  String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
            Text(size)
            Spacer()
            Button("Delete", role: .destructive, action: action)
                //.background(.cyan)
                .shadow(radius: 7)
                
            
            
        }
    }
}

struct CacheCellview_Previews: PreviewProvider {
    static var previews: some View {
        CacheCellview(title: "Images", size: "20 MB", action:{})
    }
}
