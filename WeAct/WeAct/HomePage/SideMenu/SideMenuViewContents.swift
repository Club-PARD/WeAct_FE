//
//  SideMenuViewContents.swift
//  WeAct
//
//  Created by 최승아 on 7/1/25.
//

import SwiftUI

struct SideMenuViewContents: View {
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                SideMenuTopView()
                VStack {
                    Text("Side Menu")
                        .foregroundColor(.white)
                }.frame( maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(.gray)
        }
    }
    
    func SideMenuTopView() -> some View {
        VStack {
            HStack {
                Button(action: {
                    presentSideMenu.toggle()
                }, label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                })
                .frame(width: 34, height: 34)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 40)
        .padding(.top, 40)
        .padding(.bottom, 30)
    }
}
//
//#Preview {
//    SideMenuViewContents()
//}
