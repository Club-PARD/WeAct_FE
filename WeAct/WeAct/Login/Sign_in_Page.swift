//  Sign_in_Page.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
import SwiftUI

struct Sign_in_Page: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var confirmPassword = ""
    @State private var isCheckingUserId = false
    @State private var userIdError: String?
    @State private var userIdStatus: String?
    @State private var passwordError: String?
    @State private var passwordLengthError = false
    @State private var passwordMismatchError = false
    @State private var isUserIdChecked = false
    @State private var isUserIdCheckingEnabled = false
    @State private var isSigningUp = false
    @State private var signupError: String?
    @State private var showErrorAlert = false
    @FocusState private var focusedField: FocusField?

    enum FocusField {
        case password
        case confirmPassword
    }

    var isFormValid: Bool {
        !userViewModel.user.userName.isEmpty &&
        userIdError == nil &&
        passwordError == nil &&
        isUserIdChecked &&
        userViewModel.user.gender != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button(action: {
                        isSigningUp = true
                        signupError = nil
                        
                        Task {
                            await userViewModel.createUserAndLogin()
                        }
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

                Group {
                    Text("이름")
                    TextField("이름 입력", text: $userViewModel.user.userName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }

                userIdField
                passwordFields

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
                    .background(isFormValid && !isSigningUp ? Color(hex: "#FF4B2F") : Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .disabled(!isFormValid || isSigningUp)
                .alert("회원가입 실패", isPresented: $showErrorAlert) {
                    Button("확인", role: .cancel) {}
                } message: {
                    Text(signupError ?? "알 수 없는 오류가 발생했습니다.")
                }
                .padding(.top, 30)
            }
            .padding()
        }
        .ignoresSafeArea(.keyboard)
        .background(Color(hex: "#F7F7F7"))
        .navigationBarHidden(true)
    }

    private var userIdField: some View {
        Group {
            Text("아이디")
            HStack {
                TextField("아이디 입력", text: Binding(
                    get: { userViewModel.user.userId ?? "" },
                    set: { newValue in
                        let currentValue = userViewModel.user.userId ?? ""
                        userViewModel.user.userId = newValue
                        isUserIdCheckingEnabled = !newValue.isEmpty
                        if newValue != currentValue {
                            isUserIdChecked = false
                            userIdError = nil
                            userIdStatus = nil
                        }
                    }
                ))
                .padding()
                .background(Color.white)
                .cornerRadius(8)

                Button(action: {
                    isCheckingUserId = true
                    Task {
                        async let result = checkUserId()
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        let checkResult = await result
                        userIdError = checkResult.error
                        userIdStatus = checkResult.status
                        isUserIdChecked = checkResult.isChecked
                        isCheckingUserId = false
                    }
                }) {
                    if isCheckingUserId {
                        ProgressView()
                            .scaleEffect(0.8)
                            .foregroundColor(.white)
                    } else {
                        Text("중복 확인")
                    }
                }
                .disabled(!isUserIdCheckingEnabled || isCheckingUserId)
                .frame(width: 100)
                .padding()
                .background((isUserIdCheckingEnabled && !isCheckingUserId) ? Color(hex: "#464646") : Color.gray.opacity(0.2))
                .foregroundColor((isUserIdCheckingEnabled && !isCheckingUserId) ? .white : .gray)
                .cornerRadius(8)
            }

            if let error = userIdError {
                Text(error).font(.caption).foregroundColor(.red)
            } else if let status = userIdStatus {
                Text(status).font(.caption).foregroundColor(.green)
            } else {
                Text("아이디 입력 조건 (ex. 4~12자 등)").font(.caption).foregroundColor(.gray)
            }
        }
    }

    private var passwordFields: some View {
        Group {
            Text("비밀번호")
            SecureField("비밀번호 입력", text: Binding(
                get: { userViewModel.user.pw ?? "" },
                set: { newValue in
                    let limited = String(newValue.prefix(12))
                    userViewModel.user.pw = limited
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
            .focused($focusedField, equals: .password)

            SecureField("비밀번호 확인", text: Binding(
                get: { confirmPassword },
                set: { newValue in
                    confirmPassword = String(newValue.prefix(12))
                    validatePassword()
                }
            ))
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(passwordMismatchError ? Color.red : Color.clear, lineWidth: 1)
            )
            .cornerRadius(8)
            .focused($focusedField, equals: .confirmPassword)

            if let error = passwordError {
                Text(error).font(.caption).foregroundColor(.red)
            } else {
                Text("비밀번호 입력 조건 (ex. 4~12자 등)").font(.caption).foregroundColor(.gray)
            }
        }
    }

    func validatePassword() {
        passwordLengthError = false
        passwordMismatchError = false

        guard let password = userViewModel.user.pw else { return }

        if password.count < 4 || password.count > 12 {
            passwordError = "비밀번호는 4~12자여야 해요"
            passwordLengthError = true
        } else {
            passwordError = nil
        }

        if !confirmPassword.isEmpty {
            if password != confirmPassword {
                passwordError = "비밀번호가 일치하지 않아요"
                passwordMismatchError = true
            } else {
                passwordMismatchError = false
            }
        }
    }

    func checkUserId() async -> (error: String?, status: String?, isChecked: Bool) {
        guard let id = userViewModel.user.userId else {
            return ("아이디가 비어 있어요", nil, false)
        }

        if id.count < 4 || id.count > 12 {
            return ("아이디는 4~12자여야 해요", nil, false)
        }

        if let isDuplicated = await userViewModel.isUserIdDuplicated(id) {
            if isDuplicated {
                return ("중복되는 아이디에요. 다시 시도 해주세요", nil, false)
            } else {
                return (nil, "사용 가능한 아이디에요", true)
            }
        } else {
            return ("서버 오류로 확인 실패했어요", nil, false)
        }
    }
}

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
                .background(isSelected ? Color(hex: "#FFF1EC") : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color(hex: "#FF4B2F") : Color.clear, lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
}
