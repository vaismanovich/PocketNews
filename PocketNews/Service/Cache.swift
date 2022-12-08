//
//  Cache.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 08.12.2022.
//

import Foundation
//import UIKit
//import UIKit.UIImage

protocol Cacheable {
    var directoryURL: URL {get}
    
    func save(_ data: Data, to path: URL)
    func get(from path: URL) -> Data?
    func remove(at path: URL)
    func fileExists(atPath path: String) -> Bool
    func createDirectory(atPath path: String)
    func sizeDescription(of path: URL) -> String
}

struct Cache: Cacheable {
    var directoryURL: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
    func save(_ data: Data, to path: URL) {
        try? data.write(to: path)
    }
    
    func get(from path: URL) -> Data? {
        try? Data(contentsOf: path)
    }
    
    func remove(at path: URL) {
        try? FileManager.default.removeItem(at: path)
    }
    
    func fileExists(atPath path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    func createDirectory(atPath path: String) {
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
    
    func sizeDescription(of path: URL) -> String {
        let directoryPath = path.path
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: directoryPath)
            else {return ""}
        
        var directorySize: Int64 = 0
        
        for content in contents {
            do {
                let fullContentPath = directoryPath + "/" +  content
                let contentAtribbutes = try FileManager.default.attributesOfItem(atPath: fullContentPath)
                directorySize += contentAtribbutes[.size] as? Int64 ?? 0
            } catch {
                continue
            }
        }
        
        let directorySizeString = ByteCountFormatter.string(fromByteCount: directorySize, countStyle: .file)
        
        return directorySizeString
    }
}

enum CachePath: String {
    case images
    case news
}
