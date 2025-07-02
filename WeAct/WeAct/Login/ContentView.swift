//
//  ContentView.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var userId: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    @State private var goToSignUp = false
    
    enum Field {
        case userId
        case password
    }
    
    var isFormValid: Bool {
        !userId.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let verticalSpacing = geometry.size.height * 0.07
                VStack(spacing: 15) {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 50)
                    
                    Text("친구와 함께 하는 습관 형성 서비스")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(.bottom, 64)
                    
                    TextField("아이디 입력", text: $userId)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .userId)
                    
                    SecureField("비밀번호 입력", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .password)
                    
                    Button(action: {
                        print("로그인 버튼 클릭됨")
                    }) {
                        Text("로그인")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Color(red: 1.0, green: 0.388, blue: 0.184),// #FF632F
                            )                        .cornerRadius(8)
                    }
                    
                    .padding(.horizontal)
                    
                    NavigationLink(destination: Sign_in_Page(), isActive: $goToSignUp) {
                        Button(action: {
                            goToSignUp = true
                        }) {
                            Text("회원가입")
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("완료") {
                            focusedField = nil
                        }
                    }
                }
            }
            .background(Color(hex: "#F7F7F7"))
        }
    }
}
