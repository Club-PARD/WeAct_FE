//
//  WeActApp.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
//

import SwiftUI

@main
struct WeActApp: App {
    @StateObject private var userViewModel = UserViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
                    .environmentObject(userViewModel)
            }
        }
    }
}
