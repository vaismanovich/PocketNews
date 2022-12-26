//
//  PocketNewsListView.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 22.11.2022.
//

import SwiftUI

struct PocketNewsListView: View {
    @StateObject private var controller = PocketNewsController()
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    methodPicker
                    periodPicker
                }
                .disabled(controller.isLoading)
                .unredacted()
                .animation(nil, value: UUID())
                .listRowSeparator(.hidden)
                
                ForEach(controller.pocketNews) { pocketNews in
                    NavigationLink {
                        NewsView(news: pocketNews)
                    } label: {
                        NewsListCellView(news: pocketNews)
                    }
                    .animation(nil, value: UUID())
                }
            }
            .overlay {noNewsView }
            .animation(.easeInOut, value: controller.isLoading)
            .redacted(reason: controller.redactedReason)
            .listStyle(.inset)
            .disableAutocorrection(true)
            .refreshable { controller.fetchNewsfromNetwork() }
            .navigationTitle("Pocket News")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .errorView(error: $controller.error)
        .onAppear(perform: controller.fetchNewsFromCacheAndNetwork)
        .sheet(isPresented: $showSettings) {
            settingsView
        }
    }
    
  
    
    var methodPicker: some View {
        Picker("Method", selection: $controller.method) {
            ForEach(NytAPI.Method.allCases) { method in
                Text("Most \(method.rawValue)")
                    .tag(method)
            }
        }
        .pickerStyle(.menu)
        .roundedShape()
    }
    
    var periodPicker: some View {
        Picker("Period", selection: $controller.period) {
            ForEach(NytAPI.Method.Period.allCases) { period in
                Text(period.description)
                    .tag(period)
            }
        }
        .pickerStyle(.menu)
        .roundedShape()
    }
    
    @ViewBuilder
    var noNewsView: some View {
        Group {
            if !controller.isLoading && controller.pocketNews.isEmpty {
                VStack {
                    Spacer()
                    Text("No News")
                    Text(":(")
                }
                .font(.largeTitle)
            }
        }
        .animation(nil, value: UUID())
    }
    
    @ViewBuilder
    var settingsView: some View {
        NavigationView {
            SettingsView()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            showSettings.toggle() }
                    }
                }
          }
     }
}

struct RoundShapeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
extension View {
    func roundedShape() -> some View {
        modifier(RoundShapeModifier())
    }
}

struct PocketNewsListView_Previews: PreviewProvider {
    static var previews: some View {
        PocketNewsListView()
    }
}


//var body: some View {
//    Text("App is under construction")
//        .padding()
//        .background(.yellow)
//        .foregroundColor(.blue)
//        .frame(maxWidth: .infinity)
//}
