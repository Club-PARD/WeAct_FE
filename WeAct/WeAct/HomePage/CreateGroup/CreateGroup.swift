//
//  CreateGroup.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct CreateGroup: View {
    @ObservedObject var groupStore: GroupStore
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
        ZStack {
            Color(hex: "F7F7F7")
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("우리 그룹만의\n규칙을 정해주세요")
                    .foregroundColor(Color(hex: "171717"))
                    .font(.custom("Pretendard-SemiBold", size: 26))
                    .padding(.bottom, 26)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("그룹 이름")
                        .foregroundColor(Color(hex: "858588"))
                        .font(.custom("Pretendard-Medium", size: 16))
                    
                    TextField("우리 그룹의 이름을 정해주세요", text: $name)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 16)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .padding(.bottom, 28)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("습관 인증 기간")
                        .foregroundColor(Color(hex: "858588"))
                        .font(.custom("Pretendard-Medium", size: 16))
                    
                    HStack {
                        Text(period.isEmpty ? "날짜를 추가해주세요" : period)
                            .foregroundColor(period.isEmpty ? Color(hex: "C6C6C6") : .black)
                        
                        Spacer()
                        
                        Button(action: {
                            showDatePicker = true
                        }) {
                            Image("calendar")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(hex: "FF4B2F"))
                                .frame(height: 24)
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 0)
                    )
                    
                    .padding(.bottom, 28)
                }
                .sheet(isPresented: $showDatePicker) {
                    VStack(alignment: .leading) {
                        Text("기간을 선택해주세요")
                            .font(.custom("Pretendard-Medium", size: 18))
                            .foregroundColor(Color(hex: "464646"))
                            .padding(.vertical, 20)
                        Divider()
                        // 현재 선택된 날짜 범위 표시
                        HStack {
                            VStack {
                                Text("시작일")
                                    .font(.custom("Pretendard-Medium", size: 14))
                                    .foregroundColor(Color(hex: "C6C6C6"))
                                Text(DateFormatter.shortDate.string(from: startDate))
                                    .font(.custom("Pretendard-Medium", size: 18))
                                    .foregroundColor(Color(hex: "464646"))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 12)
                                    .background(Color(hex: "F7F7F7"))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        isSelectingStartDate = true
                                    }
                            }
                            
                            Text("_")
                                .font(.custom("Pretendard-Medium", size: 22))
                                .foregroundColor(Color(hex: "C6C6C6"))
                            
                            VStack {
                                Text("종료일")
                                    .font(.custom("Pretendard-Medium", size: 14))
                                    .foregroundColor(Color(hex: "C6C6C6"))
                                Text(DateFormatter.shortDate.string(from: endDate))
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(hex: "FF4B2F"))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 12)
                                    .background(Color(hex: "FFEDEA"))
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        isSelectingStartDate = false
                                    }
                            } // VStack
                        } // HStack
                        .padding(.horizontal, 90)
                        .padding(.top, 18)
                        
                        
                        // 하나의 DatePicker로 시작일/종료일 선택
                        DatePicker(
                            isSelectingStartDate ? "시작일 선택" : "종료일 선택",
                            selection: isSelectingStartDate ? $startDate : $endDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .accentColor(Color(hex: "FF4B2F"))
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
                        
                        Button(action: {let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy.MM.dd"
                            
                            let start = formatter.string(from: startDate)
                            let end = formatter.string(from: endDate)
                            
                            period = "\(start) - \(end)"
                            showDatePicker = false}) {
                                Text("선택 완료")
                                    .font(.custom("Pretendard-Medium", size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(hex: "FF4B2F"))
                                    .cornerRadius(8)
                                
                            } //Button
                        
                        
                        Spacer()
                    } // VStack
                    .padding(.horizontal, 16)
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.727)])
                } // Sheet
                .cornerRadius(16)
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("습관 인증 주기")
                        .foregroundColor(Color(hex: "858588"))
                        .font(.custom("Pretendard-Medium", size: 16))
                    
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
                                    .background(selectedDays.contains(index) ? Color(hex: "#F8E6E3") : .white)
                                    .foregroundColor(selectedDays.contains(index) ? Color(hex: "FF4B2F") : Color(hex: "858588"))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedDays.contains(index) ? Color(hex: "FF4B2F") : Color.clear, lineWidth: 1)
                                    )
                            }
                        }
                    } // HStack
                } // VStack
                .padding(.bottom, 28)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("1등 보상")
                        .foregroundColor(Color(hex: "858588"))
                        .font(.custom("Pretendard-Medium", size: 16))
                    
                    TextField("소원 들어주기, 아이스크림 쏘기", text: $reward)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 16)
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .padding(.bottom, 28)
                }
                
                Spacer()
                
                Button(action: {
//                    print("🟡 [디버그] isFormValid:", isFormValid)
//                    print("🟢 [디버그] 방 이름(name):", name)
//                    print("🔵 [디버그] 기간(period):", period)
//                    print("🟣 [디버그] 선택된 요일(selectedDays):", selectedDays)
//                    print("🟠 [디버그] 선택된 요일 개수:", selectedDays.count)
//                    print("🔴 [디버그] 보상(reward):", reward)
                    
                    if isFormValid {
                    
                        CreateGroupData.shared.startDate = startDate
                        CreateGroupData.shared.endDate = endDate
                        
                        // 임시 데이터를 환경 객체에 저장
                        CreateGroupData.shared.name = name
                        CreateGroupData.shared.period = period
                        CreateGroupData.shared.reward = reward
                        CreateGroupData.shared.selectedDaysCount = selectedDays.count
                        
                        let selectedWeekdays = selectedDays.sorted().map { weekdays[$0] }
                        CreateGroupData.shared.selectedDaysString = selectedWeekdays
                        
                        navigationPath.append(NavigationDestination.addPartner)
                    } else {
                        print("⚠️ [디버그] 입력 조건이 충족되지 않아 다음으로 넘어가지 않음")
                    }
                }) {
                    Text("다음")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isFormValid ? .white : Color(hex: "C6C6C6"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isFormValid ? Color(hex: "FF4B2F") : Color(hex: "E7E7E7"))
                        .cornerRadius(8)
                }
                .disabled(!isFormValid)
                .padding(.bottom, 10)
                
                
                
            } // VStack
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .navigationTitle("그룹 만들기")
            .navigationBarTitleDisplayMode(.inline)
        }
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

// 그룹 생성 과정에서 임시 데이터를 저장하는 싱글톤
class CreateGroupData: ObservableObject {
    static let shared = CreateGroupData()
    
    @Published var name: String = ""
    @Published var period: String = ""
    @Published var reward: String = ""
    @Published var selectedDaysString: [String] = [] // 빈 배열로 수정
    @Published var selectedDaysCount: Int = 0
    @Published var habitText: String = ""
    @Published var startDate: Date = Date()
   @Published var endDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!

    
    private init() {}
    
    func reset() {
        name = ""
        period = ""
        reward = ""
        selectedDaysString = []
        selectedDaysCount = 0
        habitText = ""
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
    }
}

#Preview {
    @State var path = NavigationPath()
    let groupStore = GroupStore()
    CreateGroup(groupStore: groupStore, navigationPath: .constant(path))
}
