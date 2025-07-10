//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI

struct NotificationView: View {
    @Binding var navigationPath: NavigationPath
    @State private var isShowingRejectToast = false
    @StateObject private var viewModel = NotificationViewModel()
    
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
                            ForEach(viewModel.notifications, id: \.roomId) { item in
                                NotificationRow(
                                    model: item,
                                    onAccept: { handleAccept(item) },
                                    onReject: { handleReject(item) }
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
        .task {
            await viewModel.fetchNotifications()
        }
    }
    
    // 수락 처리
       private func handleAccept(_ item: NotificationModel) {
           Task {
               let success = await viewModel.acceptInvite(roomId: item.roomId)
               if success {
                   viewModel.removeNotification(roomId: item.roomId)
               } else {
                   // 실패 시 처리 (필요하면 에러 토스트 추가)
                   print("❌ 초대 수락 실패")
               }
           }
       }
    
    // 거절 처리
       private func handleReject(_ item: NotificationModel) {
           Task {
               let success = await viewModel.rejectInvite(roomId: item.roomId)
               if success {
                   viewModel.removeNotification(roomId: item.roomId)
                   showRejectToast()
               } else {
                   // 실패 시 처리 (필요하면 에러 토스트 추가)
                   print("❌ 초대 거절 실패")
               }
           }
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
