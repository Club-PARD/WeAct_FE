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
    
    @State private var notificationItems: [NotificationType] = [
        .groupInvite(sender: "이주원", groupName: "롱커톤 모여라"),
        .groupInvite(sender: "주현아", groupName: "숏커톤 모여라"),
        .memberNoVerification(sender: "이주원", groupName: "롱커톤 모여라")
    ]
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.white.edgesIgnoringSafeArea(.all)
                VStack{
                    Rectangle()
                      .frame(height: 8)
                      .padding(.top,9)
                      .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.98))

                    ScrollView{
                        VStack(spacing: 40) {
                            ForEach(notificationItems, id: \.id) { item in
                                NotificationRow(
                                    item: item,
                                    selectedImage: $selectedImage,
                                    onAccept: {
                                        removeItem(item)
                                    },
                                    onReject: {
                                        showRejectToast()
                                        removeItem(item)
                                    }
                                    
                                )
                            }
                        }
                        .padding(.top, 10)
                 
                        
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
    
    
    private func removeItem(_ item: NotificationType) {
       if let index = notificationItems.firstIndex(where: { $0.id == item.id }) {
           notificationItems.remove(at: index)
       }
   }//removeItem
}

#Preview {
    @State var path = NavigationPath()
    return NotificationView(navigationPath: .constant(path))
}
