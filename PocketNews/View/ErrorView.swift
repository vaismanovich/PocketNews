//
//  ErrorView.swift
//  PocketNews
//
//  Created by Vitaliy Vaisman on 26.11.2022.
//

import SwiftUI

struct ErrorView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .frame(minWidth: .zero, maxWidth: .infinity)
            .padding(15)
            .background(.red)
            .shadow(radius: 5)
            .font(.system(.body, design: .serif))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .foregroundColor(.yellow)
    }
}

struct ErrorViewModifier: ViewModifier {
    @Binding var error: Error?
    
    var show: Bool {error != nil}
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if show, let fail = error  {
                ErrorView(text: fail.localizedDescription)
                    .transition(.move(edge: .top).combined(with: AnyTransition.opacity))
                    .zIndex(1)
            }
        }
        .onChange(of: show, perform: { newValue in
            guard  newValue else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { error = nil
                }
            })
        .animation(.easeInOut(duration: 3), value: UUID())
    }
}


extension View {
    func errorView(error: Binding<Error?>) -> some View {
        modifier(ErrorViewModifier(error: error))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(text: "Error 1")
            
    }
}
