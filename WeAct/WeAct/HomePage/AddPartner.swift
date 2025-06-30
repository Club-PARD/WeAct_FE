//
//  AddPartner.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct AddPartner: View {
    @Binding var navigationPath: NavigationPath
    
    var customBackButton: some View {
            Button(action: {
                if !navigationPath.isEmpty {
                    navigationPath.removeLast()
                }
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .frame(width: 12, height: 21)
                }
                .foregroundColor(.black)
            }
        }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @State var path = NavigationPath()
        return AddPartner(navigationPath: .constant(path))
}
