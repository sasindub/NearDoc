//
//  NearDocApp.swift
//  NearDoc
//
//  Created by Sasindu Bandara on 2025-03-17.
//

import SwiftUI

@main
struct NearDocApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                  
                    ContentView() 
                }
            }
        }
    }
}
