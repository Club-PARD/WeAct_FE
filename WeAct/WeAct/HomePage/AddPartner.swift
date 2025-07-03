//
//  AddPartner.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct AddPartner: View {
    @ObservedObject var groupStore: GroupStore
    @Binding var navigationPath: NavigationPath
    @State private var selectedPartners: Set<PartnerModel> = []
    @State private var showingBottomSheet = false
    
    var isFormValid: Bool {
        return !selectedPartners.isEmpty
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
                // 헤더
                headerView
                
                // 선택된 파트너 카운트
                selectedCountView
                
                // 파트너 선택 영역
                partnerSelectionView
                
                Spacer()
                
                // 방 생성 버튼
                createRoomButton
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .navigationTitle("친구초대")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingBottomSheet) {
                PartnerSearchSheet(selectedPartners: $selectedPartners)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        Text("함께 할 친구를\n초대해 주세요")
            .foregroundColor(Color(hex: "171717"))
            .font(.system(size: 26, weight: .medium))
            .padding(.bottom, 14)
    }
    
    private var selectedCountView: some View {
        HStack {
            Text("\(selectedPartners.count)")
                .font(.custom("Pretendard-Medium", size: 16))
                .foregroundColor(Color(hex: "FF4B2F"))
            Text("명 선택되었어요")
                .font(.custom("Pretendard-Medium", size: 16))
                .foregroundColor(Color(hex: "858588"))
        }
        .padding(.bottom, 32)
    }
    
    private var partnerSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // 추가 버튼
                addButton
                
                // 내 프로필
                myProfileView
                
                // 선택된 파트너들
                selectedPartnersView
            }
            .padding(.vertical, 8)
        }
    }
    
    private var addButton: some View {
        Button(action: {
            showingBottomSheet = true
        }) {
            VStack(spacing: 7) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(25)
                    .background(Color(hex: "FF4B2F"))
                    .cornerRadius(20)
                
                Text("추가")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "FF4B2F"))
            }
        }
    }
    
    private var myProfileView: some View {
        VStack(spacing: 7) {
            Image("profile")
                .resizable()
                .scaledToFit()
                .frame(height: 70)
            
            Text("나")
                .font(.custom("Pretendard-Medium", size: 14))
                .foregroundColor(Color(hex: "464646"))
        }
    }
    
    private var selectedPartnersView: some View {
        ForEach(Array(selectedPartners), id: \.self) { partner in
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 7) {
                    // 프로필 이미지
                    if let imageName = partner.profileImageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(hex: "464646"))
                            .padding(25)
                            .background(.white)
                            .cornerRadius(20)
                    }
                    
                    Text(partner.name)
                        .font(.custom("Pretendard-Medium", size: 14))
                        .foregroundColor(Color(hex: "464646"))
                    
                    
                }
                .cornerRadius(20)
                
                Button(action: {
                    selectedPartners.remove(partner)
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 10, weight: .bold))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "464646"))
                        .clipShape(Circle())
                }
                .offset(x: 5, y: -5)
            }
        }
    }
    
    private var createRoomButton: some View {
        Button(action: createRoom) {
            Text("방 생성하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isFormValid ? .white : Color(hex: "8691A2"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? Color(hex: "40444B") : Color(hex: "EFF1F5"))
                .cornerRadius(8)
        }
        .disabled(!isFormValid)
        .padding(.bottom, 10)
    }
    
    // MARK: - Actions
    
    private func createRoom() {
        print("선택된 파트너: \(selectedPartners)")
        
        // 새로운 그룹 생성
        let newGroup = GroupModel(
            name: CreateGroupData.shared.name,
            period: CreateGroupData.shared.period,
            reward: CreateGroupData.shared.reward,
            partners: selectedPartners.map { $0.name },
            selectedDaysString: CreateGroupData.shared.selectedDaysString,
            selectedDaysCount: CreateGroupData.shared.selectedDaysCount
        )
        
        // 그룹 스토어에 추가
        groupStore.addGroup(newGroup)
        
        // 임시 데이터 초기화
        CreateGroupData.shared.reset()
        
        // 메인 화면으로 돌아가기
        navigationPath = NavigationPath()
    }
}

#Preview {
    @State var path = NavigationPath()
    let groupStore = GroupStore()
    AddPartner(groupStore: groupStore, navigationPath: .constant(path))
}
