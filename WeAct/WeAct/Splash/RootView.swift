//
//  RootView.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
//

import SwiftUI

struct RootView: View {
    @State private var isSplashActive = true

    var body: some View {
        ZStack {
            if isSplashActive {
                Splash()
            } else {
                ContentView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isSplashActive = false
                }
            }
        }
    }
}
