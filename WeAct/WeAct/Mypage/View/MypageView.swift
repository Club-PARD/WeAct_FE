//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI


struct MypageView: View {
    @Binding var navigationPath: NavigationPath
    //@ObservedObject var userModel: UserModel
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var isShowingImagePicker = false
    
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
        
            VStack{
                Text("마이페이지")
                    .font(Font.custom("Pretendard", size: 18).weight(.medium))
                    .foregroundColor(.black)
                    .frame(height: 44)
                    .padding(.vertical, 5)

                ZStack{
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 100, height: 100)
                      .background(Color(red: 0.93, green: 0.95, blue: 0.96))
                      .cornerRadius(20)
                    
                    if let imageURLString = userViewModel.user.profileImageURL,
                       let imageURL = URL(string: imageURLString),
                       let data = try? Data(contentsOf: imageURL),
                       let image = UIImage(data: data){
                           Image(uiImage: image)
                               .resizable()
                               .scaledToFill()
                               .frame(width: 100, height: 100)
                               .clipShape(RoundedRectangle(cornerRadius: 20))
                       } else {
                           Text("프로필\n사진")
                               .font(Font.custom("Pretendard", size: 16).weight(.medium))
                               .multilineTextAlignment(.center)
                               .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                       }
                    
                } //ZStack
                .padding(.top, 15)
                
                Text(userViewModel.user.username)
                  .font(Font.custom("Pretendard", size: 22).weight(.medium))
                  .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                
                HStack(alignment: .center, spacing: 10){
                    Button(action: {
                        userViewModel.changeProfileImage() 
                    }) {
                        Text("프로필 사진 변경")
                            .font(
                              Font.custom("Pretendard", size: 16)
                                .weight(.medium)
                              )
                            .foregroundColor(.white)
                    }
                    .font(Font.custom("Pretendard", size: 16).weight(.medium))
                           .foregroundColor(.white)
                           .frame(width: 144, height: 42)
                           .background(Color(red: 0.7, green: 0.74, blue: 0.78))
                           .cornerRadius(6)
                    
                    Button(action: {
                        userViewModel.goToNameEdit() 
                        navigationPath.append(NavigationDestination.nameEdit)
                    }) {
                        Text("이름 변경")
                            .font(
                              Font.custom("Pretendard", size: 16)
                                .weight(.medium)
                              )
                            .foregroundColor(.white)
                    }
                    .font(Font.custom("Pretendard", size: 16).weight(.medium))
                           .foregroundColor(.white)
                           .frame(width: 144, height: 42)
                           .background(Color(red: 0.7, green: 0.74, blue: 0.78))
                           .cornerRadius(6)
                           .padding(.vertical, 15)
                   
                }//HStack
              
                //경계바
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 375, height: 8)
                  .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                
                VStack(spacing: 40) {
                    MypageRow(navigationPath: $navigationPath, text: "내 습관 기록"){
                        print("지원 예정입니다")
                    }
                    MypageRow(navigationPath: $navigationPath, text: "로그아웃"){
                        print("로그아웃되었습니다.")
                    }
                    MypageRow(navigationPath: $navigationPath, text: "회원 탈퇴")
                    {
                        print("탈퇴되었습니다.")
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal, 20)
                
             Spacer()

            }//VStack
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $userViewModel.selectedImage)
            }
    }
}

#Preview {
    @State var path = NavigationPath()
    let userViewModel = UserViewModel()  // userModel -> userViewModel
    MypageView(navigationPath: .constant(path), userViewModel: userViewModel)
}
