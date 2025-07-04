//
//  NavigationWrapper.swift
//  WeAct
//
//  Created by 현승훈 on 7/4/25.
//


import SwiftUI

struct NavigationWrapper<Content: View>: UIViewControllerRepresentable {
    let rootView: Content
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let hosting = UIHostingController(rootView: rootView)
        let nav = UINavigationController(rootViewController: hosting)
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
