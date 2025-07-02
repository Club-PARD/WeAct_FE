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
    
    enum Field {
        case userId
        case password
    }

    var isFormValid: Bool {
        !userId.isEmpty && !password.isEmpty
    }

    var body: some View {
            VStack(spacing: 20) {
                Spacer()

                Text("서비스 로고")
                    .font(.headline)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Text("친구와 함께 하는 습관 형성 서비스")
                    .foregroundColor(.gray)
                    .font(.subheadline)

                TextField("아이디 입력", text: $userId)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .userId)

                SecureField("비밀번호 입력", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .password)

                Button(action: {
                    isLoggedIn = true
                }) {
                    Text("로그인")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding(.horizontal)

             
                    Button(action: {
                        showSignUp = true
                    }) {
                        Text("회원가입")
                            .foregroundColor(.gray)
                            .underline()
                            .padding(.top, 10)
                    }
                
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $showSignUp) {
                        Sign_in_Page()
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
