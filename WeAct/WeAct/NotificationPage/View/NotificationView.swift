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
    @State private var isShowingRejectToast = false
    
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
        .verificationRejected(sender: "이주원", reason: "다른 각도로 찍어줘...", image: UIImage(named: "example") ?? UIImage()),
        .memberNoVerification(sender: "이주원", groupName: "롱커톤 모여라")
    ]
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 375, height: 8)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                    
                    ScrollView{
                        VStack(spacing: 40) {
                            ForEach(mockItems, id: \.id) { item in
                                NotificationRow(
                                    item: item,
                                    selectedImage: $selectedImage,onReject: {
                                        showRejectToast()
                                    }
                                   
                                )
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                        
                    }//ScrollView
                }//VStack
                .background(Color.white)
                
                if isShowingRejectToast {
                     VStack {
                         Spacer()
                         ToastView(message: "그룹 초대를 거절했어요")
                             .transition(.move(edge: .bottom).combined(with: .opacity))
                             .animation(.easeInOut, value: isShowingRejectToast)
                     }
                 }//isShowingRejectToast

            }//ZStack

        }//NavigationView
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func showRejectToast() {
           isShowingRejectToast = true
           DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
               isShowingRejectToast = false
       }
   }//showRejectToast
    
}

#Preview {
    @State var path = NavigationPath()
    return NotificationView(navigationPath: .constant(path))
}
