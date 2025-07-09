//
//  ContentView.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var userId: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showSignUp = false
    @State private var showAlert = false  // ✅ 경고 팝업 상태 추가
    
    enum Field {
        case userId
        case password
    }
    
    var isFormValid: Bool {
        !userId.isEmpty && !password.isEmpty
    }
    
    var body: some View {

        ZStack {
            Color(hex: "F7F7F7")
                .edgesIgnoringSafeArea(.all)
           
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                
                Text("친구와 함께 하는 습관 형성 서비스")
                    .font(.custom("Pretendard-Medium", size: 16))
                    .foregroundColor(Color(hex: "464646"))
                    .padding(.bottom, 62)
                
                TextField("아이디 입력", text: $userId)
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .focused($focusedField, equals: .userId)
                    .padding(.bottom, 12)
                
                SecureField("비밀번호 입력", text: $password)
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .focused($focusedField, equals: .password)
                    .padding(.bottom, 18)
                
                Button(action: {
                    if isFormValid {
                        isLoggedIn = true
                        
                        Task {
                                            await login()
                                        }
                    } else {
                        showAlert = true  // ✅ 입력 안했을 때 경고 표시
                    }
                }) {
                    Text("로그인")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "FF4B2F"))
                        .cornerRadius(8)
                }

                .padding(.horizontal)

                .alert("로그인 실패", isPresented: $showAlert) {
                    Button("확인", role: .cancel) {}
                } message: {
                    Text("아이디와 비밀번호를 모두 입력해주세요.")
                }
                
                Button(action: {
                    showSignUp = true
                }) {
                    Text("회원가입")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }

            .padding(.horizontal, 17)

            .fullScreenCover(isPresented: $showSignUp) {
                Sign_in_Page().environmentObject(userViewModel)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("완료") {
                        focusedField = nil
                    }
                }
            }
        }
    }

//    func login() async {
//        do {
//            let token = try await UserService().login(userId: userId, password: password)
//            TokenManager.shared.saveToken(token)
//            userViewModel.user.userId = userId   // ✅ 여기 중요!
//            isLoggedIn = true
//            print("✅ 로그인 성공, 토큰: \(token)")
//        } catch {
//            print("❌ 로그인 에러: \(error)")
//        }
//    }
    
    func login() async {
        do {
            let token = try await UserService().login(userId: userId, password: password)
            TokenManager.shared.saveToken(token)
            userViewModel.token = token
            isLoggedIn = true
            
            // ✅ 여기서 사용자 정보 요청
            let userInfo = try await UserService().getUserInfo(token: token)
            userViewModel.user = userInfo  // ⭐️ userId, id, userName 등 할당됨
            
            print("✅ 로그인 후 사용자 정보: \(userInfo)")
            print("🧠 userId: \(userInfo.userId ?? "없음")")
            print("🧠 id: \(userInfo.id ?? -1)")
            
        } catch {
            print("❌ 로그인 에러: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
