//
//  CreateGroup.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct CreateGroup: View {
    @Binding var navigationPath: NavigationPath
    
    @State private var name = ""
    @State private var reward = ""
    @State private var period = ""
    
    @State private var showDatePicker: Bool = false
    @State private var dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let start = Date()
        let end = calendar.date(byAdding: .day, value: 7, to: start)!
        return start...end
    }() // 달력 선택 범위
    
    
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
        VStack(alignment: .leading) {
            Text("우리 방만의\n규칙을 정해주세요")
                .foregroundColor(Color(hex: "8691A2"))
                .font(.system(size: 26, weight: .medium))
                .padding(.bottom, 26)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("방 이름")
                    .foregroundColor(Color(hex: "8691A2"))
                    .font(.system(size: 16, weight: .medium))
                
                TextField("롱커톤 팀 모여~", text: $name)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(hex: "EFF1F5"))
                    .foregroundColor(Color(hex: "CACDDA"))
                    .cornerRadius(4)
                    .padding(.bottom, 28)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("기간")
                    .foregroundColor(Color(hex: "8691A2"))
                    .font(.system(size: 16, weight: .medium))
                
                HStack {
                    TextField("날짜 추가", text: $period)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(hex: "EFF1F5"))
                        .foregroundColor(Color(hex: "CACDDA"))
                        .cornerRadius(4)
                        .disabled(true) // 직접 입력 막기
                      
                    
                    Button(action: {
                                    showDatePicker = true
                                }) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                        .padding(12)
                                        .background(Color(hex: "EFF1F5"))
                                        .cornerRadius(4)
                                        
                                } //button
                } // HStack
                .padding(.bottom, 28)
            } // VStack
            .sheet(isPresented: $showDatePicker) {
                    VStack(spacing: 20) {
                        
//                        DatePicker("날짜 선택", selection: $dateRange, displayedComponents: [.date])
//                            .datePickerStyle(.graphical)
                        
                        Button("확인") {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            
                            let start = formatter.string(from: dateRange.lowerBound)
                            let end = formatter.string(from: dateRange.upperBound)
                            
                            period = "\(start) ~ \(end)"
                            showDatePicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.height(400)])
                }
            
        
            VStack(alignment: .leading, spacing: 8) {
                Text("보상")
                    .foregroundColor(Color(hex: "8691A2"))
                    .font(.system(size: 16, weight: .medium))
                
                TextField("일일 노예, 아이스크림 쏘기", text: $reward)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(hex: "EFF1F5"))
                    .foregroundColor(Color(hex: "CACDDA"))
                    .cornerRadius(4)
                    .padding(.bottom, 28)
            }
            
        } // VStack
        .padding(.horizontal, 18)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        .navigationTitle("방 만들기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @State var path = NavigationPath()
    return CreateGroup(navigationPath: .constant(path))
}

