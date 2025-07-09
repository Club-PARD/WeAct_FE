//
//  WeActApp.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
//

import SwiftUI
import SwiftData


@main
struct WeActApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                //RootView()
                //CertificationView()
                //PassCard()
                TestingPage()
            }
        }
        .modelContainer(for: User.self)
    }
}
