import SwiftUI

struct MainView: View {
    @StateObject private var groupStore = GroupStore()
    @State private var homeGroups: [HomeGroupModel] = []
    @State private var navigationPath = NavigationPath()
    @StateObject private var userViewModel = UserViewModel()
    @State private var TodayDate = Date()
    
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(hex: "F7F7F7")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.notification)
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "9FADBC"))
                        }
                        .padding(.trailing, 7)
                        
                        Button {
                            navigationPath.append(NavigationDestination.myPage)
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "9FADBC"))
                        }
                    } // HStack
                    .padding(.top, 22)
                    
                    ZStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(Calendar.current.component(.month, from: TodayDate))")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "FF4B2F"))
                                
                                Text("월")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "171717"))
                                
                                Text("\(Calendar.current.component(.day, from: TodayDate))")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "FF4B2F"))
                                
                                Text("일")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "171717"))
                            } // HStack
                            
                            Text("습관 인증 해볼까요?")
                                .foregroundColor(Color(hex: "171717"))
                                .font(.custom("Pretendard-SemiBold", size: 26))
                        } // VStack
                        
                        HStack {
                            Spacer()
                            Image("IllustHome")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 92)
                        } // HStack
                    } // HStack
                    .padding(.top, 25)
                    
                    // 그룹 없을 때
                    if homeGroups.isEmpty {
                        HStack {
                            Spacer()
                            VStack {
                                Image("NoGroup")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.bottom, 32)
                                    .padding(.top, UIScreen.main.bounds.height * 0.106)
                                
                                Text("생성된 습관 그룹이 없어요\n 그룹을 추가해 주세요")
                                    .foregroundColor(Color(hex: "C6C6C6"))
                                    .font(.custom("Pretendard-Medium", size: 20))
                                    .multilineTextAlignment(.center)
                            } // VStack
                            Spacer()
                        } // HStack
                    }
                    // 그룹 있을 때
                    else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(groupStore.groups) { group in
                                    GroupList(
                                                                           navigationPath: $navigationPath,
                                                                           homeGroup: convertToHomeGroupModel(from: group),
                                                                           group: group,
                                                                           onTap: {
                                                                               navigationPath.append(NavigationDestination.groupBoard(group))
                                                                           }
                                                                       )
                                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 그룹 만들기 버튼
                    HStack {
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.createGroup)
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Text("그룹 만들기")
                                    .foregroundColor(.white)
                                    .font(.custom("Pretendard-Medium", size: 16))
                            } // HStack
                            .padding(.vertical, 11)
                            .padding(.horizontal, 18)
                            .background(Color(hex: "464646"))
                            .cornerRadius(30)
                        } // Button
                        .padding(.bottom, 42)
                    } // HStack
                    .padding(.horizontal, 4)
                    
                }
                .padding(.horizontal, 20)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .createGroup:
                        CreateGroup(groupStore: groupStore, navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .addPartner:
                        AddPartner(groupStore: groupStore, navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .groupBoard(let group):
                        GroupDetailBoard(navigationPath: $navigationPath, groupResponse: nil, group: group, groupStore: groupStore)
                    case .notification:
                        NotificationView(navigationPath: $navigationPath)
                    case .myPage:
                        MypageView(navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .nameEdit:
                        NameEditView(navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .certification:
                        CertificationView()
                    case .setuphabit:
                        SetUpHabbit(navigationPath: $navigationPath)
                    }
                }
            } // ZStack
            .onAppear {
                            fetchHomeGroups()
                        }
                        .onChange(of: navigationPath) { oldValue, newValue in
                            // 네비게이션 스택이 비어있을 때 (홈화면으로 돌아왔을 때) 그룹 목록 새로고침
                            if newValue.isEmpty {
                                print("🔄 홈화면으로 돌아옴 - 그룹 목록 새로고침")
                                fetchHomeGroups()
                            }
                        }
        } // NavigationStack
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helpers
        
        private func convertToHomeGroupModel(from group: GroupModel) -> HomeGroupModel {
            // GroupModel → HomeGroupModel 변환 (필요한 경우)
            return HomeGroupModel(
                roomId: 1,
                roomName: group.name,
                habit: group.habitText,
                period: datePeriodString(from: group.startDate, to: group.endDate),
                dayCountByWeek: group.selectedDaysCount,
                percent: 0 // 아직 달성률이 없으면 0으로 처리
            )
        }
        
        private func datePeriodString(from startDate: Date, to endDate: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))"
        }
        
        // MARK: - 데이터 요청
        private func fetchHomeGroups() {
            Task {
                do {
                    // 🔧 개선된 userId 검증 로직
                    guard let userId = userViewModel.user.userId else {
                        
                        print("❌ 현재 사용자 상태 - userId: \(userViewModel.user.userId ?? "없음")")
                      
                        return
                    }
                    
                    print("📡 [요청 시작] userId: \(userId)")
                    
                    let response = try await HomeGroupService.shared.getHomeGroups(userId: userId)
                    
                    print("📡 [요청 URL] https://naruto.asia/user/home/\(userId)")
                    print("✅ [서버 응답 성공] 받은 그룹 수: \(response.roomInformationDtos.count)")
                    
                    // 메인 스레드에서 UI 업데이트
                    await MainActor.run {
                        // 서버 응답에서 날짜 정보 업데이트
                        if let date = Calendar.current.date(from: DateComponents(month: response.month, day: response.day)) {
                            self.TodayDate = date
                        }
                        
                        // 서버에서 받은 데이터 배열 업데이트
                        self.homeGroups = response.roomInformationDtos
                        
                        // 화면에서 실제 쓰는 groups 배열 업데이트
                        self.groupStore.groups = response.roomInformationDtos.map { homeGroup in
                            GroupModel(
                                id: homeGroup.roomId ?? Int.random(in: 0...9999), // 서버에서 roomId 제공시 사용
                                name: homeGroup.roomName,
                                startDate: parseDate(from: homeGroup.period) ?? Date(),
                                endDate: parseEndDate(from: homeGroup.period) ?? Date(),
                                reward: "보상 미정", // 서버에서 제공하지 않으면 기본값
                                partners: [], // 서버에 데이터 없으면 빈 배열
                                selectedDaysString: "", // 서버에서 제공하지 않으면 빈 문자열
                                selectedDaysCount: homeGroup.dayCountByWeek,
                                habitText: homeGroup.habit
                            )
                        }
                        
                        print("✅ [UI 업데이트 완료] 표시할 그룹 수: \(self.groupStore.groups.count)")
                    }
                    
                } catch {
                    print("❌ 홈 그룹 조회 실패:", error.localizedDescription)
                    
                    // 오류 발생시 디버깅 정보 추가 출력
                    await MainActor.run {
                        print("❌ 홈 그룹 조회 실패:", error.localizedDescription)
                    }
                }
            }
        }
        
        // MARK: - 날짜 파싱 헬퍼 함수들
        private func parseDate(from period: String) -> Date? {
            let components = period.components(separatedBy: " ~ ")
            guard let startString = components.first else { return nil }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.date(from: startString)
        }
        
        private func parseEndDate(from period: String) -> Date? {
            let components = period.components(separatedBy: " ~ ")
            guard components.count > 1 else { return nil }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.date(from: components[1])
        }
    }


#Preview {
    let testUserModel = UserViewModel()
     MainView()
        .environmentObject(testUserModel)
}
