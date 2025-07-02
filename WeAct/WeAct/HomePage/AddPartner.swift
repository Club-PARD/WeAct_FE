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
    @State private var selectedPartners: Set<String> = []
    @State private var selectedDaysString: Set<String> = []
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
        VStack(alignment: .leading) {
            Text("함께 할\n친구를 초대해주세요")
                .foregroundColor(Color(hex: "8691A2"))
                .font(.system(size: 26, weight: .medium))
                .padding(.bottom, 26)
            
            Text("\(selectedPartners.count)명 선택되었어요")
                           .font(.system(size: 16, weight: .medium))
                           .foregroundColor(Color(hex: "4C5B73"))
            
            // 파트너 추가 버튼
            Button(action: {
                showingBottomSheet = true
            }) {
                VStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color(hex: "8691A2"))
                    
                    Text("파트너 추가")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "8691A2"))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color(hex: "F8F9FA"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "E9ECEF"), lineWidth: 1)
                )
                .cornerRadius(8)
            }
            
            // 선택된 파트너 목록
            if !selectedPartners.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("선택된 파트너")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "40444B"))
                        .padding(.top, 20)
                    
                    ForEach(Array(selectedPartners), id: \.self) { partner in
                        HStack {
                            Circle()
                                .fill(Color(hex: "40444B"))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    //Text(String(partner.first ?? "U"))
                                    Image(systemName: "person")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                )
                            
                            Text(partner)
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "40444B"))
                            
                            Spacer()
                            
                            Button(action: {
                                selectedPartners.remove(partner)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color(hex: "8691A2"))
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(hex: "F8F9FA"))
                        .cornerRadius(8)
                    }
                }
            }
            
            
            Spacer()
            
            Button(action: {
                print("선택된 파트너: \(selectedPartners)")
                // 새로운 그룹 생성
                                let newGroup = GroupModel(
                                    name: CreateGroupData.shared.name,
                                    period: CreateGroupData.shared.period,
                                    reward: CreateGroupData.shared.reward,
                                    partners: Array(selectedPartners),
                                    selectedDaysString: Array(selectedDaysString),
                                    selectedDaysCount: CreateGroupData.shared.selectedDaysCount
                                )
                                
                                // 그룹 스토어에 추가
                                groupStore.addGroup(newGroup)
                                
                                // 임시 데이터 초기화
                                CreateGroupData.shared.reset()
                                
                                // 메인 화면으로 돌아가기
                                navigationPath = NavigationPath()
            }) {
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

#Preview {
    @State var path = NavigationPath()
    let groupStore = GroupStore()
    AddPartner(groupStore: groupStore, navigationPath: .constant(path))
}
