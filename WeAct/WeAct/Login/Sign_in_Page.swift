//  Sign_in_Page.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.

import SwiftUI

struct Sign_in_Page: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showWelcome = false
    @State private var confirmPassword = ""
    
    // 상태 관리
    @State private var userIdError: String?
    @State private var userIdStatus: String?
    @State private var passwordError: String?
    @State private var passwordLengthError = false
    @State private var passwordMismatchError = false
    @State private var isUserIdChecked = false
    @State private var isUserIdCheckingEnabled = false
    // @State private var navigateToWelcome = false  // ✅ fullScreenCover 트리거
    
    @State private var isSigningUp = false
    @State private var signupError: String?
    @State private var showErrorAlert = false
    
    var isFormValid: Bool {
        !userViewModel.user.userName.isEmpty &&
        userIdError == nil &&
        passwordError == nil &&
        isUserIdChecked &&
        userViewModel.user.gender != nil
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
                            
                            
                        }
                        Spacer()
                        Text("회원가입")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    // 이름
                    Group {
                        Text("이름")
                        TextField("이름 입력", text: $userViewModel.user.userName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    
                    //아이디
                    userIdField
                    
                    //비밀번호
                    passwordFields
                    // 성별
                    Group {
                        Text("성별")
                        HStack {
                            GenderButton(title: "남자", isSelected: userViewModel.user.gender == "남자") {
                                userViewModel.user.gender = "남자"
                            }
                            GenderButton(title: "여자", isSelected: userViewModel.user.gender == "여자") {
                                userViewModel.user.gender = "여자"
                            }
                        }
                    }
                    
                    // 회원가입 버튼
                    //                    Button(action: {
                    //                        //서버통신
                    //                        Task {
                    //                            do {
                    //                                let response = try await userViewModel.createUser(user: userViewModel.user)
                    //                                userViewModel.user.id = response.id  // 🔑 서버에서 받은 id만 업데이트
                    //                                print("✅ 회원가입 성공")
                    //                                print("🧑‍💻 유저 ID: \(userViewModel.user.id ?? -1)")
                    //                                print("🧠 ViewModel (회원가입 페이지): \(Unmanaged.passUnretained(userViewModel).toOpaque())")
                    //                                showWelcome = true
                    //                            } catch {
                    //                                print("❌ 회원가입 실패: \(error.localizedDescription)")
                    //                            }
                    //                        }
                    //                        //showWelcome = true
                    //                    }) {
                    //                        Text("회원가입")
                    //                            .foregroundColor(.white)
                    //                            .frame(maxWidth: .infinity)
                    //                            .padding()
                    //                            .background(isFormValid ? Color.init(hex: "#FF4B2F") : Color.gray.opacity(0.2))
                    //                            .cornerRadius(8)
                    //                    }
                    //                    .disabled(!isFormValid)
                    //                    .padding(.top, 30)
                    
                    // 회원가입 버튼 액션 부분만 수정
                    
                    Button(action: {
                        isSigningUp = true
                        signupError = nil
                        
                        Task {
                                await userViewModel.createUserAndLogin()
                            }
                    }) {
                        HStack {
                            if isSigningUp {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            Text(isSigningUp ? "가입중..." : "회원가입")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid && !isSigningUp ? Color.init(hex: "#FF4B2F") : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .disabled(!isFormValid || isSigningUp)
                    .alert("회원가입 실패", isPresented: $showErrorAlert) {
                        Button("확인", role: .cancel) { }
                    } message: {
                        Text(signupError ?? "알 수 없는 오류가 발생했습니다.")
                    }
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
        guard let id = userViewModel.user.userId else { return }
        
        if id.count < 4 || id.count > 12 {
            userIdError = "아이디는 4~12자여야 해요"
            userIdStatus = nil
            isUserIdChecked = false
            return
        }
        
        Task {
            if let isDuplicated = await userViewModel.isUserIdDuplicated(id) {
                if isDuplicated {
                    userIdError = "중복되는 아이디에요. 다시 시도 해주세요"
                    userIdStatus = nil
                    isUserIdChecked = false
                } else {
                    userIdError = nil
                    userIdStatus = "사용 가능한 아이디에요"
                    isUserIdChecked = true
                }
            } else {
                
                userIdStatus = nil
                isUserIdChecked = false
            }
        }
    }
    
    // 아이디
    private var userIdField: some View {
        Group {
            Text("아이디")
            HStack {
                TextField("아이디 입력", text: Binding(
                    get: { userViewModel.user.userId ?? "" },
                    set: {
                        userViewModel.user.userId = $0
                        isUserIdCheckingEnabled = !$0.isEmpty
                        isUserIdChecked = false
                        userIdError = nil
                        userIdStatus = nil
                    }
                ))
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                Button("중복 확인") {
                    checkUserId()
                }
                .disabled(!isUserIdCheckingEnabled)
                .frame(width: 100)
                .padding()
                .background(isUserIdCheckingEnabled ? Color.init(hex: "#464646") : Color.gray.opacity(0.2))
                .foregroundColor(isUserIdCheckingEnabled ? .white : .gray)
                .cornerRadius(8)
            }//HStack
            
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
        }//Group
    }//userIdField
    
    
    // 비밀번호
    private var passwordFields: some View {
        Group {
            Text("비밀번호")
            SecureField("비밀번호 입력", text: Binding(
                get: { userViewModel.user.pw ?? "" },
                set: {
                    userViewModel.user.pw = $0
                    validatePassword()
                }
            ))
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(passwordLengthError ? Color.red : Color.clear, lineWidth: 1)
            )
            .cornerRadius(8)
            
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
    }// passwordFields
    
    func validatePassword() {
        passwordLengthError = false
        passwordMismatchError = false
        
        guard let password = userViewModel.user.pw else { return }
        
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


struct Sign_in_Page_Previews: PreviewProvider {
    static var previews: some View {
        Sign_in_Page()
            .environmentObject(UserViewModel())  // 💡 EnvironmentObject 주입
    }
}
