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
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var isSelectingStartDate = true // 시작일 선택 중인지 여부
    
    @State private var selectedDays: Set<Int> = [] // 선택된 요일들 (0: 일요일, 1: 월요일, ...)
    
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    
    var isFormValid: Bool { // 모든 필드가 채워졌는가
        return !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !period.isEmpty &&
        !selectedDays.isEmpty &&
        !reward.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
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
                    .foregroundColor(.black)
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
                        .foregroundColor(.black)
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
                    }
                }
                .padding(.bottom, 28)
            }
            .sheet(isPresented: $showDatePicker) {
                VStack(spacing: 20) {
                    Text("기간 선택")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top)
                    
                    // 현재 선택된 날짜 범위 표시
                    HStack {
                        VStack {
                            Text("시작일")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(DateFormatter.shortDate.string(from: startDate))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(isSelectingStartDate ? .blue : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(isSelectingStartDate ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    isSelectingStartDate = true
                                }
                        }
                        
                        Text("~")
                            .foregroundColor(.secondary)
                        
                        VStack {
                            Text("종료일")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(DateFormatter.shortDate.string(from: endDate))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(!isSelectingStartDate ? .blue : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(!isSelectingStartDate ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    isSelectingStartDate = false
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 하나의 DatePicker로 시작일/종료일 선택
                    DatePicker(
                        isSelectingStartDate ? "시작일 선택" : "종료일 선택",
                        selection: isSelectingStartDate ? $startDate : $endDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .onChange(of: startDate) { newStartDate in
                        // 시작일이 종료일보다 늦으면 종료일을 시작일로 설정
                        if newStartDate > endDate {
                            endDate = newStartDate
                        }
                    }
                    .onChange(of: endDate) { newEndDate in
                        // 종료일이 시작일보다 이르면 시작일을 종료일로 설정
                        if newEndDate < startDate {
                            startDate = newEndDate
                        }
                    }
                    
                    Button("확인") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        
                        let start = formatter.string(from: startDate)
                        let end = formatter.string(from: endDate)
                        
                        period = "\(start) ~ \(end)"
                        showDatePicker = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .presentationDetents([.height(500)])
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("주기")
                    .foregroundColor(Color(hex: "8691A2"))
                    .font(.system(size: 16, weight: .medium))
                
                HStack(spacing: 8) {
                    ForEach(0..<weekdays.count, id: \.self) { index in
                        Button(action: {
                            if selectedDays.contains(index) {
                                selectedDays.remove(index)
                            } else {
                                selectedDays.insert(index)
                            }
                        }) {
                            Text(weekdays[index])
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 40, height: 40)
                                .background(selectedDays.contains(index) ? Color(hex: "40444B") : Color(hex: "EFF1F5"))
                                .foregroundColor(selectedDays.contains(index) ? .white : Color(hex: "8691A2"))
                                .cornerRadius(4)
                        }
                    }
                } // HStack
            } // VStack
            .padding(.bottom, 28)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("보상")
                    .foregroundColor(Color(hex: "8691A2"))
                    .font(.system(size: 16, weight: .medium))
                
                TextField("일일 노예, 아이스크림 쏘기", text: $reward)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(hex: "EFF1F5"))
                    .foregroundColor(.black)
                    .cornerRadius(4)
                    .padding(.bottom, 28)
            }
            
            Spacer()
            
            Button(action: {
                print("방 이름: \(name)")
                print("기간: \(period)")
                print("선택된 요일: \(SelectedDaysString())")
                print("주 \(SelectedDaysCount())회")
                print("보상: \(reward)")
              
                navigationPath.append(NavigationDestination.addPartner)
            }) {
                Text("다음")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isFormValid ? .white : Color(hex: "8691A2"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isFormValid ? Color(hex: "40444B") : Color(hex: "EFF1F5"))
                    .cornerRadius(8)
            }
            .disabled(!isFormValid)
            .padding(.bottom, 10)
        } // VStack
        .padding(.vertical, 18)
        .padding(.horizontal, 18)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton, trailing: Button {
        } label: {
            
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 74)
                .foregroundColor((Color(hex: "9FADBC")))
            
        } // Button
                            )
        .navigationTitle("방 만들기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
}

// 선택된 요일들을 문자열로 변환
extension CreateGroup {
    private func SelectedDaysString() -> String { // 선택된 요일들을 "월, 화, 수" 형태
        let selectedWeekdays = selectedDays.sorted().map { weekdays[$0] }
        return selectedWeekdays.joined(separator: ", ")
    }
    
    private func SelectedDaysCount() -> Int { // 선택된 요일의 개수 반환
        return selectedDays.count
    }
}


#Preview {
    @State var path = NavigationPath()
    return CreateGroup(navigationPath: .constant(path))
}
