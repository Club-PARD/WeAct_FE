//
//  SetUpHabbit.swift
//  WeAct
//
//  Created by 최승아 on 7/3/25.
//

import SwiftUI

struct SetUpHabbit: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var myHabbit = ""
    @State private var selectedTime = Date()
    @State private var showTimePicker = false
    @State private var isTimeSelected = false
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    var roomId: Int
    
    var customBackButton: some View {
        Button(action: {
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 12, height: 21)
            }
            .foregroundColor(.black)
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "F7F7F7")
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("어떤 습관을 달성해 볼까요?")
                        .foregroundColor(Color(hex: "858588"))
                        .font(.custom("Pretendard-Medium", size: 16))
                        .padding(.top, 22)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                        HStack {
                            TextField("10분 독서", text: $myHabbit)
                                .onChange(of: myHabbit) { newValue in
                                    if newValue.count > 10 {
                                        myHabbit = String(newValue.prefix(10))
                                    }
                                }
                            
                            Spacer()
                            
                            Text("\(myHabbit.count)/10")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .padding(.trailing, 4)
                        } // HStack
                        .padding(.horizontal, 22)
                        .padding(.vertical, 16)
                    } // ZStack
                    .frame(height: 50)
                    .padding(.bottom, 28)
                } // VStack
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("습관 인증 알림 시간을 설정해 주세요.")
                        .foregroundColor(Color(hex: "858588"))
                        .font(.custom("Pretendard-Medium", size: 16))
                    
                    Button(action: {
                        showTimePicker = true
                    }) {
                        HStack {
                            Text("\(getAMPM(selectedTime)) \(formatTime(selectedTime))")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(Color(hex: "171717"))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "858588"))
                        } // HStack
                        .padding(.horizontal, 22)
                        .padding(.vertical, 16)
                        .background(.white)
                        .cornerRadius(8)
                    } // Button
                } // VStack
                Spacer()
                Button(action: {
                    Task {
                        await submitHabit()
                    }
                }) {
                    Text("확인")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background((myHabbit.isEmpty || !isTimeSelected) ? Color(hex: "E7E7E7") : Color(hex: "FF4B2F"))
                        .cornerRadius(8)
                    
                } //Button
                .disabled(myHabbit.isEmpty || !isTimeSelected)
                .padding(.bottom, 18)
            } // VStack
            .sheet(isPresented: $showTimePicker) {
                VStack {
                    HStack {
                        Text("알림 시간을 선택해 주세요")
                            .font(.custom("Pretendard-Medium", size: 18))
                            .foregroundColor(Color(hex: "495159"))
                        
                        
                        Spacer()
                        
                        Button(action: {
                            showTimePicker = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color(hex: "858588"))
                        }
                    } // HStack
                    .padding(.vertical, 20)
                    .padding(.horizontal, 16)
                    
                    
                    Divider().padding(.horizontal, 16)
                    
                    DatePicker("시간 선택", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .onChange(of: selectedTime) { _ in
                            isTimeSelected = true
                        }
                    
                    Button(action: {
                        isTimeSelected = true
                        showTimePicker = false
                    }) {
                        Text("확인")
                            .font(.custom("Pretendard-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "FF4B2F"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    
                } // VStack
                .cornerRadius(16)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])
            } // sheet
            
            .padding(.horizontal, 16)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .navigationTitle("내 습관 설정")
            .navigationBarTitleDisplayMode(.inline)
            .alert("오류", isPresented: $showErrorAlert) {
                Button("확인") { }
            } message: {
                Text(errorMessage)
            }
        } // ZStack
    }
    
    private func submitHabit() async {
        guard !myHabbit.isEmpty else {
            errorMessage = "습관을 입력해 주세요."
            showErrorAlert = true
            return
        }
        
        guard isTimeSelected else {
            errorMessage = "알림 시간을 선택해 주세요."
            showErrorAlert = true
            return
        }
        
        isLoading = true
        
        // 1. 토큰 새로고침 (TokenManager와 동기화)
        userViewModel.refreshTokenFromStorage()
        
        // 2. 시간 포맷팅 - 띄어쓰기 있는 형태로 서버에 전송
        let remindTime = "\(getAMPM(selectedTime)) \(formatTime(selectedTime))"
        
        // 3. 기존 검증 로직 그대로 유지
        guard let token = userViewModel.token else {
            errorMessage = "로그인이 필요합니다."
            showErrorAlert = true
            isLoading = false
            return
        }
        
        print("🔍 [SetUpHabbit] habit 업데이트 시작")
        print("🔍 [SetUpHabbit] roomId: \(roomId)")
        print("🔍 [SetUpHabbit] habit: \(myHabbit)")
        print("🔍 [SetUpHabbit] remindTime: \(remindTime)")
        print("🔍 [SetUpHabbit] token exists: \(token.count > 0)")
        
        do {
            try await HabitService.shared.updateHabit(token: token, roomId: roomId, habit: myHabbit, remindTime: remindTime)
            
            CreateGroupData.shared.habitText = myHabbit
            CreateGroupData.shared.reset()
            
            await MainActor.run {
                navigationPath.removeLast(navigationPath.count) // 메인으로 돌아가기
            }
        } catch let error as HabitServiceError {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        } catch {
            errorMessage = "습관 설정 저장에 실패했습니다.\n\(error.localizedDescription)"
            showErrorAlert = true
        }
        
        isLoading = false
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"  // 12시간 형식으로 변경
        return formatter.string(from: date)
    }
    
    private func getAMPM(_ date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        return hour < 12 ? "오전" : "오후"
    }
}
