//
//  SettingsView.swift
//  PocketNews
//
//  Created by Мария Шувалова on 08.12.2022.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var controller = SettingsController()
    
    var imagesCacheTitle: String {
        controller.imagesCasheSize.isEmpty ? "0 KB": controller.imagesCasheSize
    }
    
    var newsCacheTitle: String {
        controller.pocketNewsCasheSize.isEmpty ? "0 KB": controller.pocketNewsCasheSize
    }
    
    var body: some View {
        List {
            Section(header: Text("Cache Settings")) {
                CacheCellview(
                    title: "PocketNews",
                    size: newsCacheTitle,
                    action: controller.deleteNewsCache)
                
                CacheCellview(
                    title: "Images",
                    size: imagesCacheTitle,
                    action: controller.deleteImagesCache)
                
                Button("Delete all cache", role: .destructive, action: controller.deleteAllCache)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
            .onAppear(perform: controller.setAllCacheSize)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background")
            .sheet(isPresented: .constant(true)) {
                SettingsView()
            }
      }
}
