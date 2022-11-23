//
//  PocketNewsController.swift
//  PocketNews
//
//  Created by Мария Шувалова on 22.11.2022.
//

import SwiftUI
import Combine

final class PocketNewsController: ObservableObject {
    @Published private(set) var pocketNews = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    @AppStorage(AppStorageKeys.method.rawValue) var method
}


enum AppStorageKeys: String {
    case method
    case period
}
