import SwiftUI

struct SideMenuViewContents: View {
    @Binding var navigationPath: NavigationPath
    @Binding var presentSideMenu: Bool
    @State var isDisplayTooltip: Bool = false
    @State private var hamburgerInfo: HamburgerModel?
    @State private var isLoadingHamburger = false
    @State private var errorMessage: String?
    @State private var isShowingExitGroupModal = false
    let roomId: Int
    let token: String
    
    var body: some View {
        ZStack {
            // 메인 컨텐츠
            VStack {
                // 상단 헤더
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            presentSideMenu.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color(hex: "858588"))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isDisplayTooltip = true
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color(hex: "858588"))
                        }
                        
                        Button(action: {
                            // 공유 버튼 액션
                        }) {
                            Image("share")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(hex: "858588"))
                        }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 18)
                    
                    // 로딩 상태 또는 그룹 정보
                    if isLoadingHamburger {
                        // 로딩 중일 때
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(hex: "F0F0F0"))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(0.8)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Rectangle()
                                    .fill(Color(hex: "F0F0F0"))
                                    .frame(width: 100, height: 20)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(Color(hex: "F0F0F0"))
                                    .frame(width: 150, height: 16)
                                    .cornerRadius(4)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                    } else if let hamburgerInfo = hamburgerInfo {
                        // 데이터 로드 완료
                        VStack(alignment: .leading) {
                            HStack {
                                // 프로필 이미지
                                if let imageURLString = hamburgerInfo.imageUrl,
                                   let imageURL = URL(string: imageURLString) {
                                    AsyncImage(url: imageURL) { phase in
                                        switch phase {
                                        case .empty:
                                            Image("BasicProfile")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                            
                                        @unknown default:
                                            Image("BasicProfile")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                    }
                                    .frame(width: 48, height: 48)
                                    .cornerRadius(14)
                                } else {
                                    Image("BasicProfile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(14)
                                }
                                
                                
                                Text(hamburgerInfo.myName)
                                    .font(.custom("Pretendard-Bold", size: 22))
                                    .foregroundColor(Color(hex: "171717"))
                                
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                HStack(spacing: 6) {
                                    Image("pen")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                    
                                    Text(hamburgerInfo.myHabit ?? "습관을 설정해주세요")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "464646"))
                                }
                                .padding(.bottom, 9)
                                
                                HStack(spacing: 6) {
                                    Image("icon_goal")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                    
                                    Text("내 습관 달성률")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "464646"))
                                    
                                    Spacer()
                                    
                                    let safePercent = max(0, min(100, hamburgerInfo.myPercent))
                                    Text("\(safePercent)%")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color(hex: "FF4B2F"))
                                }
                                
                                
                                // 진행률 바
                                let progressValue = Double(hamburgerInfo.myPercent) / 100.0
                                ProgressView(value: progressValue)
                                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "FF4B2F")))
                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                                    .padding(.top, 11)
                                
                            }
                        }
                        .padding(.horizontal, 20)
                        
                    } else if let errorMessage = errorMessage {
                        // 오류 상태
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 24))
                                .foregroundColor(Color(hex: "FF6B47"))
                            
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "666666"))
                                .multilineTextAlignment(.center)
                            
                            Button("다시 시도") {
                                fetchHamburgerInfo()
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "FF6B47"))
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 24)
                
                // 구분선
                Rectangle()
                    .fill(Color(hex: "F7F7F7"))
                    .frame(height: 8)
                
                // 멤버 목록
                if let hamburgerInfo = hamburgerInfo {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("친구 목록")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "333333"))
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 12)
                            
                            Spacer()
                            
                            Text("\(hamburgerInfo.memberNameAndHabitDtos.count)명")
                                .font(.custom("Pretendard-Medium", size: 14))
                                .foregroundColor(Color(hex: "8691A2"))
                                .padding(.trailing, 20)
                        }
                        
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(hamburgerInfo.memberNameAndHabitDtos.indices, id: \.self) { index in
                                    let member = hamburgerInfo.memberNameAndHabitDtos[index]
                                    HStack(spacing: 12) {
                                        // 멤버 프로필 이미지
                                        AsyncImage(url: URL(string: member.imageUrl)) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            case .failure(_):
                                                Image("BasicProfile")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            case .empty:
                                                Image("BasicProfile")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            @unknown default:
                                                Image("BasicProfile")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            }
                                        }
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(14)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(member.memberName)
                                                .font(.custom("Pretendard-Medium", size: 16))
                                                .foregroundColor(Color(hex: "464646"))
                                            
                                            Text(member.memberHabit ?? "습관 없음")
                                                .font(.custom("Pretendard-Regular", size: 14))
                                                .foregroundColor(Color(hex: "858588"))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Divider()
                    .foregroundColor(Color(hex: "EFF1F5"))
                
                Button(action: {
                    isShowingExitGroupModal = true
                }) {
                    Text("그룹 나가기")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "FF6B47"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 12)
                        .padding(.bottom, 34)
                        .padding(.leading, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            
            // 툴팁 오버레이
            if isDisplayTooltip {
                TooltipView(isDisplayTooltip: $isDisplayTooltip)
                    .offset(x: -25, y: -275)
                    .zIndex(1)
            }
        }
        .onTapGesture {
            isDisplayTooltip = false
        }
        .onAppear {
            fetchHamburgerInfo()
        }
        // 모달 오버레이를 여기에 추가 (사이드 메뉴를 포함한 전체 화면에 적용)
        .overlay(
            // 모달이 표시될 때만 전체 화면 오버레이 적용
            isShowingExitGroupModal ?
            Color.black.opacity(0.6)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    isShowingExitGroupModal = false
                }
                .overlay(
                    CustomModalView(
                        title: "그룹을 나갈까요?",
                        message: "그룹을 나가면 인증 기록이 사라지고\n다시 입장할 수 없어요.",
                        firstButtonTitle: "취소",
                        secondButtonTitle: "그룹 나가기",
                        firstButtonAction: {
                            isShowingExitGroupModal = false
                            print("취소 버튼 클릭")
                        },
                        secondButtonAction: {
                            isShowingExitGroupModal = false
                            exitGroup()
                            print("그룹 나가기 버튼 클릭")
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 85)
                )
            : nil
        )
    }
    
    // MARK: - 그룹 나가기
    private func exitGroup() {
        print("🚪 [exitGroup] 시작 - roomId: \(roomId)")
        
        guard !token.isEmpty else {
            print("❌ [exitGroup] 액세스 토큰이 없습니다")
            errorMessage = "인증 토큰이 없습니다. 다시 로그인해 주세요."
            return
        }
        
        Task {
            do {
                try await HamburgerService.shared.exitGroup(
                    roomId: String(roomId),
                    token: token
                )
                
                await MainActor.run {
                    print("✅ [exitGroup] 성공")
                    presentSideMenu = false
                    navigationPath = NavigationPath()
                }
            } catch {
                await MainActor.run {
                    print("❌ [exitGroup] 실패: \(error)")
                    
                    if let nsError = error as NSError? {
                        switch nsError.code {
                        case 401:
                            self.errorMessage = "인증이 필요합니다. 다시 로그인해 주세요."
                        case 403:
                            self.errorMessage = "그룹에서 나갈 권한이 없습니다."
                        case 404:
                            self.errorMessage = "존재하지 않는 그룹입니다."
                        case 500:
                            self.errorMessage = "서버 오류가 발생했습니다."
                        default:
                            self.errorMessage = "그룹 나가기에 실패했습니다. (코드: \(nsError.code))"
                        }
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            self.errorMessage = "인터넷 연결을 확인해 주세요."
                        case .timedOut:
                            self.errorMessage = "요청 시간이 초과되었습니다."
                        default:
                            self.errorMessage = "네트워크 오류가 발생했습니다."
                        }
                    } else {
                        self.errorMessage = "알 수 없는 오류가 발생했습니다."
                    }
                }
            }
        }
    }
    
    // MARK: - 햄버거 정보 가져오기
    private func fetchHamburgerInfo() {
        print("🔍 [fetchHamburgerInfo] 시작 - roomId: \(roomId)")
        
        guard !token.isEmpty else {
            print("❌ [fetchHamburgerInfo] 액세스 토큰이 없습니다")
            errorMessage = "인증 토큰이 없습니다. 다시 로그인해 주세요."
            return
        }
        
        isLoadingHamburger = true
        errorMessage = nil
        
        Task {
            do {
                let hamburgerInfo = try await HamburgerService.shared.getHamburger(
                    roomId: String(roomId),
                    token: token
                )
                
                await MainActor.run {
                    print("✅ [fetchHamburgerInfo] 성공")
                    print("📦 내 이름: \(hamburgerInfo.myName)")
                    print("📦 내 습관: \(hamburgerInfo.myHabit ?? "없음")")
                    print("📦 진행률: \(hamburgerInfo.myPercent)%")
                    print("📦 멤버 수: \(hamburgerInfo.memberNameAndHabitDtos.count)")
                    
                    self.hamburgerInfo = hamburgerInfo
                    self.isLoadingHamburger = false
                }
            } catch {
                await MainActor.run {
                    print("❌ [fetchHamburgerInfo] 실패: \(error)")
                    self.isLoadingHamburger = false
                    
                    if let nsError = error as NSError? {
                        switch nsError.code {
                        case 401:
                            self.errorMessage = "인증이 필요합니다. 다시 로그인해 주세요."
                        case 403:
                            self.errorMessage = "접근 권한이 없습니다."
                        case 404:
                            self.errorMessage = "존재하지 않는 그룹입니다."
                        case 500:
                            self.errorMessage = "서버 오류가 발생했습니다."
                        default:
                            self.errorMessage = "정보를 불러오는데 실패했습니다. (코드: \(nsError.code))"
                        }
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            self.errorMessage = "인터넷 연결을 확인해 주세요."
                        case .timedOut:
                            self.errorMessage = "요청 시간이 초과되었습니다."
                        default:
                            self.errorMessage = "네트워크 오류가 발생했습니다."
                        }
                    } else {
                        self.errorMessage = "알 수 없는 오류가 발생했습니다."
                    }
                }
            }
        }
    }
}

private struct TooltipView: View {
    @Binding var isDisplayTooltip: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            TooltipShapeView()
                .onTapGesture {
                    isDisplayTooltip = false
                }
        }
    }
}

struct SideView<RenderView: View>: View {
    @Binding var isShowing: Bool
    var direction: Edge
    @ViewBuilder var content: RenderView
    
    var body: some View {
        ZStack(alignment: direction == .trailing ? .trailing : .leading) {
            if isShowing {
                // 배경 오버레이 - 이전 페이지가 비치도록
                Color.black
                    .opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                
                // 사이드 메뉴 컨텐츠
                HStack(spacing: 0) {
                    if direction == .trailing {
                        Spacer()
                    }
                    
                    content
                        .frame(width: UIScreen.main.bounds.width * 0.76)
                        .background(Color.white)
                        .transition(.move(edge: direction))
                    
                    if direction == .leading {
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
