//
//  ContentView.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var userId: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
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
                Sign_in_Page(userViewModel: UserViewModel())
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
}



#Preview {
    ContentView()
}
