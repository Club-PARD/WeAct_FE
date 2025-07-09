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
    @State private var showAlert = false  // 경고 팝업 상태 추가
    @State private var alertMessage = "아이디와 비밀번호를 모두 입력해주세요."
    
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
                        Task {
                            await login()
                        }
                    } else {
                        alertMessage = "아이디와 비밀번호를 모두 입력해주세요."
                        showAlert = true
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
                    Text(alertMessage)
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
    //            userViewModel.token = token
    //            isLoggedIn = true
    //
    //            // ✅ 여기서 사용자 정보 요청
    //            let userInfo = try await UserService().getUserInfo(token: token)
    //            userViewModel.user = userInfo  // ⭐️ userId, id, userName 등 할당됨
    //
    //            print("✅ 로그인 후 사용자 정보: \(userInfo)")
    //            print("🧠 userId: \(userInfo.userId ?? "없음")")
    //            print("🧠 id: \(userInfo.id ?? -1)")
    //
    //        } catch {
    //            print("❌ 로그인 에러: \(error)")
    //        }
    //    }
    func login() async {
        do {
            let token = try await UserService().login(userId: userId, password: password)
            TokenManager.shared.saveToken(token)
            
            let userInfo = try await UserService().getUserInfo(token: token)
            userViewModel.user = userInfo
            
            print("✅ 로그인 성공, 유저 ID: \(userInfo.id ?? -1)")
            isLoggedIn = true
        } catch {
            if let nsError = error as NSError? {
                print("❌ 로그인 실패: code=\(nsError.code), message=\(nsError.localizedDescription)")
                
                switch nsError.code {
                case 401:
                    alertMessage = "아이디 또는 비밀번호가 올바르지 않습니다."
                case 404:
                    alertMessage = "존재하지 않는 계정입니다."
                case 500:
                    alertMessage = "서버 오류입니다. 잠시 후 다시 시도해주세요."
                default:
                    alertMessage = nsError.localizedDescription
                }
            } else {
                alertMessage = "알 수 없는 오류가 발생했습니다."
            }
            showAlert = true
        }
    }

    
}

#Preview {
    ContentView()
}
