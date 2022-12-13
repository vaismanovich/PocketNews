//
//  PocketNewsController.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 22.11.2022.
//

import SwiftUI
import Combine

final class PocketNewsController: ObservableObject {
    @Published private(set) var pocketNews: [News] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    @AppStorage(AppStorageKeys.method.rawValue) var method: NytAPI.Method = .viewed
    
    
}


enum AppStorageKeys: String {
    case method
    case period
}
