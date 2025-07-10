//
//  GroupDetailBoard.swift
//  WeAct
//
//  Created by 최승아 on 7/1/25.
//

import SwiftUI

struct GroupDetailBoard: View {
    @Binding var navigationPath: NavigationPath
    let groupResponse: GroupResponse?
    let group: GroupModel
    @ObservedObject var groupStore: GroupStore
    @State var presentSideMenu = false
    @State private var showDatePicker: Bool = false
    
    // 날짜 관련 상태 추가
    @State private var currentDate = Date()
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var isSelectingStartDate = true
    @State private var period = ""
    
    @State private var showImagePicker = false
    
    @State private var isAllCompleted = false // 모든 멤버가 인증했는지
    @State private var canCertifyToday = false // 오늘 인증 가능한지 (선택한 요일인지)
    
    // 날짜 포맷터
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 그룹 기간을 파싱하는 계산 프로퍼티
    private var groupStartDate: Date {
        let periodComponents = group.period.components(separatedBy: " - ")
        if let startString = periodComponents.first {
            return dateFormatter.date(from: startString) ?? Date()
        }
        return Date()
    }
    
    private var groupEndDate: Date {
        let periodComponents = group.period.components(separatedBy: " - ")
        if periodComponents.count > 1 {
            return dateFormatter.date(from: periodComponents[1]) ?? Date()
        }
        return Date()
    }
    
    // 현재 날짜가 그룹 기간 내에 있는지 확인
    private var isCurrentDateInRange: Bool {
        let calendar = Calendar.current
        return calendar.compare(currentDate, to: groupStartDate, toGranularity: .day) != .orderedAscending &&
        calendar.compare(currentDate, to: groupEndDate, toGranularity: .day) != .orderedDescending
    }
    
    // 이전 날짜로 갈 수 있는지 확인
    private var canGoPrevious: Bool {
        let calendar = Calendar.current
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else { return false }
        return calendar.compare(previousDate, to: groupStartDate, toGranularity: .day) != .orderedAscending
    }
    
    // 다음 날짜로 갈 수 있는지 확인
    private var canGoNext: Bool {
        let calendar = Calendar.current
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { return false }
        return calendar.compare(nextDate, to: groupEndDate, toGranularity: .day) != .orderedDescending
    }
    
    // 토큰을 가져오는 헬퍼 함수
        private func getAccessToken() -> String? {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
    
    // checkDays API 호출 함수 (NetworkService 사용)
        private func checkDays() {
            print("🔍 [checkDays] =================")
            print("🔍 [checkDays] 함수 호출됨")
            print("🔍 [checkDays] 그룹 ID: \(group.id)")
            print("🔍 [checkDays] 현재 날짜: \(displayDateFormatter.string(from: currentDate))")
            print("🔍 [checkDays] 그룹 선택 요일: \(group.selectedDaysString)")
            print("🔍 [checkDays] 현재 canCertifyToday 상태: \(canCertifyToday)")
            print("🔍 [checkDays] =================")
            
            // 토큰 확인
            guard let accessToken = getAccessToken() else {
                print("❌ [checkDays] 액세스 토큰이 없습니다")
                canCertifyToday = false
                return
            }
            
            print("🔑 [checkDays] 토큰 확인 완료")
            
            // API URL 구성
            let urlString = "\(APIConstants.baseURL)/room/checkDays/\(group.id)"
            
            print("📡 [checkDays] API URL: \(urlString)")
            
            guard let url = URL(string: urlString) else {
                print("❌ [checkDays] URL 생성 실패")
                canCertifyToday = false
                return
            }
            
            print("🚀 [checkDays] API 요청 시작...")
            
            // NetworkService를 사용한 비동기 API 호출
            Task {
                do {
                    let result: Bool = try await NetworkService.shared.get(url: url, accessToken: accessToken)
                    
                    // 메인 스레드에서 UI 업데이트
                    await MainActor.run {
                        print("✅ [checkDays] API 호출 성공: \(result)")
                        print("🔄 [checkDays] canCertifyToday: \(canCertifyToday) -> \(result)")
                        canCertifyToday = result
                        print("🎯 [checkDays] 최종 인증 가능 여부: \(canCertifyToday)")
                        print("🖼️ [checkDays] UI 업데이트 완료 - 인증 버튼 표시 여부: \(isCurrentDateInRange && canCertifyToday)")
                    }
                    
                } catch {
                    // 메인 스레드에서 에러 처리
                    await MainActor.run {
                        print("❌ [checkDays] API 호출 실패: \(error)")
                        
                        // HTTP 에러 코드 확인
                        if let nsError = error as NSError?, nsError.code == 500 {
                            print("❌ [checkDays] 서버 오류 발생 (500)")
                            print("❌ [checkDays] 그룹의 days 필드가 설정되지 않았을 수 있습니다")
                        }
                        
                        canCertifyToday = false
                        print("🔄 [checkDays] canCertifyToday -> false (API 호출 실패)")
                    }
                }
            }
            
            print("🔍 [checkDays] 처리 완료 =================")
        }
        
        // oneDayCount API 호출 함수 (NetworkService 사용)
        private func checkOneDayCount() {
            print("🔍 [DEBUG] checkOneDayCount 호출됨")
            
            guard isCurrentDateInRange else {
                print("❌ [DEBUG] 현재 날짜가 그룹 기간 외입니다.")
                return
            }
            
            // 토큰 확인
            guard let accessToken = getAccessToken() else {
                print("❌ [DEBUG] 액세스 토큰이 없습니다")
                return
            }
            
            print("🔑 [DEBUG] 토큰 확인 완료")
            
            // API URL 구성
            let dateString = apiDateFormatter.string(from: currentDate)
            let urlString = "\(APIConstants.baseURL)/room/oneDayCount?roomId=\(group.id)&date=\(dateString)"
            
            print("📡 [DEBUG] API URL: \(urlString)")
            print("📅 [DEBUG] 요청 날짜: \(dateString)")
            print("🏠 [DEBUG] 그룹 ID: \(group.id)")
            
            guard let url = URL(string: urlString) else {
                print("❌ [DEBUG] URL 생성 실패")
                return
            }
            
            print("🚀 [DEBUG] API 요청 시작...")
            
            // NetworkService를 사용한 비동기 API 호출
            Task {
                do {
                    let result: Bool = try await NetworkService.shared.get(url: url, accessToken: accessToken)
                    
                    // 메인 스레드에서 UI 업데이트
                    await MainActor.run {
                        print("✅ [DEBUG] API 호출 성공: \(result)")
                        isAllCompleted = result
                        print("🎯 [DEBUG] 해당 날짜 모든 멤버 인증 완료: \(result)")
                    }
                    
                } catch {
                    // 메인 스레드에서 에러 처리
                    await MainActor.run {
                        print("❌ [DEBUG] API 호출 실패: \(error)")
                        
                        // HTTP 에러 코드 확인
                        if let nsError = error as NSError? {
                            print("❌ [DEBUG] 에러 코드: \(nsError.code)")
                        }
                        
                        isAllCompleted = false
                        print("🔄 [DEBUG] isAllCompleted -> false (API 호출 실패)")
                    }
                }
            }
        }
    
    var customBackButton: some View {
        Button(action: {
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24))
            }
            .foregroundColor(.black)
        }
    }
    
    var hamburgerMenuButton: some View {
        Button(action: {
            presentSideMenu.toggle()
        }) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 24))
                .foregroundColor(.black)
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "F7F7F7")
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 상단 네비게이션 (날짜 버튼들 제거)
                HStack {
                    customBackButton
                    
                    Spacer()
                    
                    // 현재 날짜 표시 및 날짜 선택 버튼
                    Button(action: {
                        showDatePicker = true
                    }) {
                        Text(displayDateFormatter.string(from: currentDate))
                            .font(.custom("Pretendard-Medium", size: 18))
                            .foregroundColor(Color(hex: "464646"))
                    }
                    .sheet(isPresented: $showDatePicker) {
                        VStack(alignment: .leading) {
                            Text("날짜를 선택해주세요")
                                .font(.custom("Pretendard-Medium", size: 18))
                                .foregroundColor(Color(hex: "464646"))
                                .padding(.vertical, 20)
                            Divider()
                            
                            // 단일 날짜 선택 (그룹 기간 내로 제한)
                            DatePicker(
                                "날짜 선택",
                                selection: $currentDate,
                                in: groupStartDate...groupEndDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .accentColor(Color(hex: "FF4B2F"))
                            .onChange(of: currentDate) { _ in
                                // 날짜가 변경될 때 API 호출
                                checkOneDayCount()
                            }
                            
                            Button(action: {
                                showDatePicker = false
                            }) {
                                Text("선택 완료")
                                    .font(.custom("Pretendard-Medium", size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(hex: "FF4B2F"))
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .presentationDetents([.height(UIScreen.main.bounds.height * 0.6)])
                    }
                    
                    Spacer()
                    
                    hamburgerMenuButton
                }
                .background(Color.clear)
                
                // 그룹 정보
                VStack(alignment: .leading) {
                    HStack {
                        Text(group.name)
                            .font(.custom("Pretendard-Bold", size: 22))
                            .foregroundColor(Color(hex: "171717"))
                        Spacer()
                        
                        Text(group.periodShort2)
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundColor(Color(hex: "858588"))
                    }
                    
                    HStack {
                        Text("주기")
                            .font(.system(size: 14))
                            .padding(.vertical, 3)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "858588"))
                            .background(Color(hex: "F7F7F7"))
                            .cornerRadius(6)
                        
                        Text(group.selectedDaysString.toDisplayDays())
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "464646"))
                    }
                    
                    HStack {
                        Text("보상")
                            .font(.system(size: 14))
                            .padding(.vertical, 3)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "858588"))
                            .background(Color(hex: "F7F7F7"))
                            .cornerRadius(6)
                        
                        Text(group.reward)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "464646"))
                    } // HStack
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 20)
                .background(.white)
                .cornerRadius(16)
                .padding(.top, 20)
                
                
                // 중간 랭킹 추가
                VStack(alignment: .leading) {
                    CheckPointRankingView(roomId: group.id)
                }
                //.padding(.horizontal, 22)
                .padding(.vertical, 20)
                
                
                ZStack {
                    // 날짜 네비게이션 (그룹 정보 아래로 이동)
                    HStack {
                        // 이전 날짜 버튼
                        Button(action: {
                            if canGoPrevious {
                                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                                checkOneDayCount()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .frame(width: 6, height: 12)
                                .foregroundColor(canGoPrevious ? Color(hex: "8691A2") : Color(hex: "C6C6C6"))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .background(.white)
                                .cornerRadius(8)
                        }
                        .disabled(!canGoPrevious)
                        
                        Spacer()
                        
                        // 다음 날짜 버튼
                        Button(action: {
                            if canGoNext {
                                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                                checkOneDayCount()
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .frame(width: 6, height: 12)
                                .foregroundColor(canGoNext ? Color(hex: "8691A2") : Color(hex: "C6C6C6"))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .background(.white)
                                .cornerRadius(8)
                        }
                        .disabled(!canGoNext)
                    }
                    .padding(.vertical, 50)
                    
                    VStack {
                        // 선택된 날짜의 보드 내용 표시 (기간 내 날짜만)
                        if isCurrentDateInRange {
                            // 여기에 보드 내용 표시
                            Text("선택된 날짜: \(displayDateFormatter.string(from: currentDate))\n         (확인용)")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(Color(hex: "464646"))
                                .padding()
                        } else {
                            // 기간 외 날짜일 때는 메시지 표시
                            Text("해당 날짜는 그룹 활동 기간이 아닙니다.")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(Color(hex: "8691A2"))
                                .padding()
                        }
                    }
                }
                
                Spacer()
                
                // 인증하기 버튼 (기간 내 날짜이면서 선택한 요일일 때만 표시)
                                if isCurrentDateInRange && canCertifyToday {
                    // 그룹 만들기 버튼
                    HStack {
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.certification)
                        } label: {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Text("인증하기")
                                    .foregroundColor(.white)
                                    .font(.custom("Pretendard-Medium", size: 16))
                            }
                            .padding(.vertical, 11)
                            .padding(.horizontal, 18)
                            .background(Color(hex: "FF4B2F"))
                            .cornerRadius(30)
                        }
                        .padding(.bottom, 42)
                    }
                    .padding(.horizontal, 4)
                    
                }
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // 초기 날짜를 그룹 시작 날짜로 설정
                currentDate = groupStartDate
                checkDays() // 선택한 요일 확인
                checkOneDayCount()
            }
            .onChange(of: currentDate) { _ in
                // 날짜가 변경될 때마다 API 호출
                checkOneDayCount()
            }
            
            SideView(isShowing: $presentSideMenu, direction: .trailing) {
                SideMenuViewContents(presentSideMenu: $presentSideMenu)
            }
            
        }
    }
}

extension String {
    // "월화수" -> "월, 화, 수"
    func toDisplayDays() -> String {
        return self.map { String($0) }.joined(separator: ", ")
    }
}

#Preview {
    // 테스트용
    let calendar = Calendar.current
    let startDate = calendar.date(from: DateComponents(year: 2025, month: 7, day: 8)) ?? Date()
    let endDate = calendar.date(from: DateComponents(year: 2025, month: 7, day: 9)) ?? Date()
    let testGroup = GroupModel(
        id: 11,
        name: "아침 운동 챌린지",
        startDate: startDate,
        endDate: endDate,
        reward: "맛있는 브런치 먹기",
        partners: [],
        selectedDaysString: "월화수목금",
        selectedDaysCount: 5,
    )
    
    // 테스트용 GroupStore 생성
    let testGroupStore = GroupStore()
    
    // StatefulPreviewWrapper를 사용하여 NavigationPath 상태 관리
    StatefulPreviewWrapper(NavigationPath()) { path in
        NavigationStack(path: path) {
            GroupDetailBoard(
                navigationPath: path,
                groupResponse: nil,
                group: testGroup,
                groupStore: testGroupStore
            )
        }
    }
}
