//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI


struct MypageView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userViewModel: UserViewModel
    @AppStorage("isLoggedIn") var isLoggedIn = true
    @State private var isShowingLogoutModal = false
    @State private var isShowingDeleteAccountModal = false
    
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
        NavigationView {
            ZStack {
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 100, height: 100)
                            .background(Color(red: 0.93, green: 0.95, blue: 0.96))
                            .cornerRadius(20)
                        
                        if let localImage = userViewModel.user.localProfileImage {
                            Image(uiImage: localImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 94, height: 94)
                                .clipped()
                                .cornerRadius(20)
                        } else if let imageURLString = userViewModel.user.profileImageURL,
                                   let imageURL = URL(string: imageURLString) {
                               AsyncImage(url: imageURL) { phase in
                                   switch phase {
                                   case .empty:
                                       ProgressView()
                                           .frame(width: 94, height: 94)
                                   case .success(let image):
                                       image
                                           .resizable()
                                           .scaledToFill()
                                           .frame(width: 94, height: 94)
                                           .clipped()
                                           .cornerRadius(20)
                                   case .failure(_):
                                       Text("이미지 오류")
                                           .frame(width: 94, height: 94)
                                           .background(Color.gray)
                                           .cornerRadius(20)
                                   @unknown default:
                                       EmptyView()
                                   }
                               }
                           }
                        else {
                            Text("프로필\n사진")
                               .font(.custom("Pretendard-Medium", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                        }
                        
                    } //ZStack
                    .padding(.top, 39)
                    .padding(.bottom, 13)
                    
                    Text(userViewModel.user.userName)
                        .font(.custom("Pretendard-Medium", size: 22))
                        .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                    
                    
                    HStack(alignment: .center, spacing: 10){
                        Button(action: {
                            userViewModel.changeProfileImage()
                        }) {
                            Text("프로필 사진 변경")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.27))
                        }
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 146, height: 46)
                        .background(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
                        )
                        
                        
                        Button(action: {
                            userViewModel.goToNameEdit()
                            navigationPath.append(NavigationDestination.nameEdit)
                        }) {
                            Text("이름 변경")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.27))
                        }
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 146, height: 46)
                        .background(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
                        )
                        
                    }//HStack
                    .padding(.bottom, 38)
                    .padding(.top, 23)
                    
                    
                    VStack(spacing: 40) {
                        MypageRow(navigationPath: $navigationPath, text: "내 습관 기록"){
                            print("지원 예정입니다")
                        }
                        MypageRow(navigationPath: $navigationPath, text: "로그아웃"){
                            print("로그아웃되었습니다.")
                            isShowingLogoutModal = true
                        }
                        
                        MypageRow(navigationPath: $navigationPath, text: "회원 탈퇴")
                        {
                            print("탈퇴되었습니다.")
                            isShowingDeleteAccountModal = true
                        }
                        
                        Spacer()
                    }//VStack-MypageRow
                    .padding(.top, 31)
                    .padding(.horizontal, 19)
                    .background(.white)
                    
                }//VStack
                .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                .sheet(isPresented: $userViewModel.isShowingImagePicker) {
                    ImagePicker(image: $userViewModel.selectedImage)
                }
                if isShowingLogoutModal {
                   Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                   CustomModalView(
                       title: "로그아웃하시겠습니까?",
                       message: "계정에서 로그아웃합니다.\n언제든 다시 로그인할 수 있어요.",
                       firstButtonTitle: "취소",
                       secondButtonTitle: "로그아웃",
                       firstButtonAction: {
                           isShowingLogoutModal=false
                           print("취소 버튼 클릭")
                       },
                       secondButtonAction: {
                           isShowingLogoutModal=false
                           isLoggedIn = false
                           navigationPath = NavigationPath()
                           print("로그아웃 버튼 클릭")
                           TokenManager.shared.deleteToken()
                                          isLoggedIn = false
                       }
                   )
               }//isShowingLogoutModal
                if isShowingDeleteAccountModal {
                   Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                   CustomModalView(
                       title: "탈퇴하시겠습니까?",
                       message: "탈퇴 시 모든 정보가 삭제되며,\n 복구가 불가능합니다.",
                       firstButtonTitle: "취소",
                       secondButtonTitle: "탈퇴하기",
                       firstButtonAction: {
                           isLoggedIn = false
                           navigationPath = NavigationPath()
                           isShowingDeleteAccountModal=false
                           print("취소 버튼 클릭")
                           
                       },
                       secondButtonAction: {
                           Task {
                              await userViewModel.deleteUser()
                          }
                           isShowingDeleteAccountModal=false
                           print("탈퇴하기 버튼 클릭")
                       }
                   )
               }//isShowingDeleteAccountModal
                
            }//ZStack
        }//NavigationView
        .onAppear {
            print("📍 MypageView 진입")
            print("🧠 ViewModel (마이페이지): \(Unmanaged.passUnretained(userViewModel).toOpaque())")
            print("🧑‍💻 유저 ID: \(userViewModel.user.id ?? -1)")

            Task {
                userViewModel.refreshTokenFromStorage() // 🔁 토큰 불러오기
                await userViewModel.fetchSimpleProfile()    // 🔁 사용자 정보 불러오기 (프로필 포함)
            }
        }

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        .navigationTitle("마이페이지")
        .navigationBarTitleDisplayMode(.inline)
    }
}
