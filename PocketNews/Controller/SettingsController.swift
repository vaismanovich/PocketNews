//
//  SettingsController.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 06.12.2022.
//

import Foundation
import SwiftUI

final class SettingsController: ObservableObject {
    @Published var imagesCasheSize = ""
    @Published var pocketNewsCasheSize = ""
    
    private let cache: Cacheable
    
    init (cache: Cacheable = Cache()) {
        self.cache = cache
    }
    
    
    func setAllCacheSize() {
        setImagesCacheSize()
        setNewsCacheSize()
    }
    
    func deleteAllCache() {
        removeCache(at: .images)
        removeCache(at: .news)
        
        setAllCacheSize()
    }
    
    func deleteNewsCache() {
        removeCache(at: .news)
        setNewsCacheSize()
    }
    
    func deleteImagesCache() {
        removeCache(at: .images)
        setImagesCacheSize()
    }
    
    private func setNewsCacheSize() {
        let directoryURL = cache.directoryURL.appendingPathComponent(CachePath.news.rawValue)
        
        pocketNewsCasheSize = cache.sizeDescription(of: directoryURL)
    }
    
    private func setImagesCacheSize() {
        let directoryURL = cache.directoryURL.appendingPathComponent(CachePath.images.rawValue)
        
        imagesCasheSize = cache.sizeDescription(of: directoryURL)
    }
    
    private func removeCache(at path: CachePath) {
        let directoryURL = cache.directoryURL.appendingPathComponent(path.rawValue)
        
        cache.remove(at: directoryURL)
    }
}
