//
//  SetUpHabbit.swift
//  WeAct
//
//  Created by 최승아 on 7/3/25.
//

import SwiftUI

struct SetUpHabbit: View {
    @Binding var navigationPath: NavigationPath
    @State private var myHabbit = ""
    @State private var selectedTime = Date()
    @State private var showTimePicker = false
    @State private var isTimeSelected = false
    
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
                    CreateGroupData.shared.habitText = myHabbit
                       
                       // 여기서 데이터 초기화
                       CreateGroupData.shared.reset()
                       
                       // 스택을 모두 비워서 메인으로 이동
                       navigationPath.removeLast(navigationPath.count)
                }) {
                        Text("확인")
                            .font(.custom("Pretendard-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background((myHabbit.isEmpty && !isTimeSelected ? Color(hex: "E7E7E7") : Color(hex: "FF4B2F")))
                            .cornerRadius(8)
                        
                    } //Button
                .disabled(myHabbit.isEmpty && !isTimeSelected)
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
                    
       
                } // VStack
                .cornerRadius(16)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.403)])
            } // sheet
            
            .padding(.horizontal, 16)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .navigationTitle("내 습관 설정")
            .navigationBarTitleDisplayMode(.inline)
        } // ZStack
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func getAMPM(_ date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        return hour < 12 ? "오전" : "오후"
    }
}

#Preview {
    @State var path = NavigationPath()
    SetUpHabbit(navigationPath: .constant(path))
}
