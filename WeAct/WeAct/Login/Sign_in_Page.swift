//  Sign_in_Page.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.

import SwiftUI

struct Sign_in_Page: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showWelcome = false
    
    @State private var name = ""
    @State private var userId = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedGender: String? = nil
    
    // 상태 관리
    @State private var userIdError: String?
    @State private var userIdStatus: String?
    @State private var passwordError: String?
    @State private var passwordLengthError = false
    @State private var passwordMismatchError = false
    @State private var isUserIdChecked = false
    @State private var isUserIdCheckingEnabled = false
    // @State private var navigateToWelcome = false  // ✅ fullScreenCover 트리거
    
    var isFormValid: Bool {
        !name.isEmpty &&
        userIdError == nil &&
        passwordError == nil &&
        isUserIdChecked &&
        selectedGender != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // 상단 바
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                            Text("회원가입")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    // 이름
                    Group {
                        Text("이름")
                        TextField("이름 입력", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    
                    // 아이디
                    Group {
                        Text("아이디")
                        HStack {
                            TextField("아이디 입력", text: $userId)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .onChange(of: userId) { newValue in
                                    isUserIdCheckingEnabled = !newValue.isEmpty
                                    isUserIdChecked = false
                                    userIdError = nil
                                    userIdStatus = nil
                                }
                            
                            Button("중복 확인") {
                                checkUserId()
                            }
                            .disabled(!isUserIdCheckingEnabled)
                            .frame(width: 100)
                            .padding()
                            .background(isUserIdCheckingEnabled ? Color.init(hex: "#464646") : Color.gray.opacity(0.2))
                            .foregroundColor(isUserIdCheckingEnabled ? .white : .gray)
                            .cornerRadius(8)
                        }
                        
                        if let error = userIdError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        } else if let status = userIdStatus {
                            Text(status)
                                .font(.caption)
                                .foregroundColor(.green)
                        } else {
                            Text("아이디 입력 조건 (ex. 4~12자 등)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 비밀번호
                    Group {
                        Text("비밀번호")

                        SecureField("비밀번호 입력", text: $password)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(passwordLengthError ? Color.red : Color.clear, lineWidth: 1)
                            )
                            .cornerRadius(8)
                            .onChange(of: password) { _ in
                                validatePassword()
                            }
                        
                        SecureField("비밀번호 확인", text: $confirmPassword)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(passwordMismatchError ? Color.red : Color.clear, lineWidth: 1)
                            )
                            .cornerRadius(8)
                            .onChange(of: confirmPassword) { _ in
                                validatePassword()
                            }
                        
                        if let error = passwordError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        } else {
                            Text("비밀번호 입력 조건 (ex. 4~12자 등)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 성별
                    Group {
                        Text("성별")
                        HStack {
                            GenderButton(title: "남자", isSelected: selectedGender == "남자") {
                                selectedGender = "남자"
                            }
                            GenderButton(title: "여자", isSelected: selectedGender == "여자") {
                                selectedGender = "여자"
                            }
                        }
                    }
                    
                    // 회원가입 버튼
                    Button(action: {
                        showWelcome = true
                    }) {
                        Text("회원가입")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.init(hex: "#FF4B2F") : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid)
                    .padding(.top, 30)
                }
                .fullScreenCover(isPresented: $showWelcome) {
                    WelcomePage()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
            .background(Color(hex: "#F7F7F7"))
        }
        
    }
    
    // MARK: - 유효성 검사
    
    func checkUserId() {
        if userId.count < 4 || userId.count > 12 {
            userIdError = "아이디는 4~12자여야 해요"
            userIdStatus = nil
            isUserIdChecked = false
        } else if userId.lowercased() == "2weeksone" {
            userIdError = "중복되는 아이디에요. 다시 시도 해주세요"
            userIdStatus = nil
            isUserIdChecked = false
        } else {
            userIdError = nil
            userIdStatus = "사용 가능한 아이디에요"
            isUserIdChecked = true
        }
    }
    
    func validatePassword() {
        passwordLengthError = false
        passwordMismatchError = false

        if password.count < 4 || password.count > 12 {
            passwordError = "비밀번호는 4~12자여야 해요"
            passwordLengthError = true
        } else if password != confirmPassword {
            passwordError = "비밀번호가 일치하지 않아요"
            passwordMismatchError = true
        } else {
            passwordError = nil
        }
    }
}

// MARK: - 성별 버튼
struct GenderButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isSelected ? Color(hex: "#FF4B2F") : .gray)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    isSelected ? Color(hex: "#FFF1EC") : .white
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color(hex: "#FF4B2F") : Color.clear, lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
}
