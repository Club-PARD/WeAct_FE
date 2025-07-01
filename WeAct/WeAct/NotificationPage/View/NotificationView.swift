//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI

struct NotificationView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePopupPresented = false
    
    private var customBackButton: some View {
            Button(action: {
                if !navigationPath.isEmpty {
                    navigationPath.removeLast()
                }
            }) {
                Image(systemName: "chevron.left")
                    .frame(width: 12, height: 21)
                    .foregroundColor(.black)
            }
        }
    
    let mockItems: [NotificationType] = [
        .groupInvite(sender: "이주원", groupName: "롱커톤 모여라"),
        .groupInvite(sender: "주현아", groupName: "숏커톤 모여라"),
               .verificationRejected(sender: "이주원", reason: "다른 각도로 찍어줘...", image: UIImage(named: "example") ?? UIImage()),
               .memberNoVerification(sender: "이주원", groupName: "롱커톤 모여라")
    ]
    
    var body: some View {
        VStack{
            Text("알림")
                .font(Font.custom("Pretendard", size: 18).weight(.medium))
                .foregroundColor(.black)
                .frame(height: 44)
                .padding(.vertical, 5)

            //경계바
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 375, height: 8)
                .background(Color(red: 0.97, green: 0.97, blue: 0.98))
            
            ScrollView{
                VStack(spacing: 40) {
                    ForEach(mockItems, id: \.id) { item in
                       NotificationRow(
                        item: item,
                        selectedImage: $selectedImage,
                        isImagePopupPresented:$isImagePopupPresented)
                        
                   }
                }
                .padding(.top, 10)
                .padding(.horizontal, 5)
                
                Spacer()
                
            }//VStack
        }//ScrollView
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        .background(Color.white)
        .sheet(isPresented: $isImagePopupPresented) {
           if let image = selectedImage {
               ZStack {
                   Color.black.opacity(0.9).ignoresSafeArea()
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFit()
                       .padding()
               }
               .onTapGesture {
                   isImagePopupPresented = false
               }
           }
       }
    }
}

#Preview {
    @State var path = NavigationPath()
    return NotificationView(navigationPath: .constant(path))
}
