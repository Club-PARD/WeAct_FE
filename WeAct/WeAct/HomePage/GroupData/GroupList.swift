//
//  GroupList.swift
//  WeAct
//
//  Created by 최승아 on 7/1/25.
//

import SwiftUI

struct GroupList: View {
    let group: GroupModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(group.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "40444B"))
                        Text("\(group.partners.count)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8691A2"))
                    } // HStack
                    
                    HStack {
                        Text("\(group.period)")
                            .font(.system(size: 14))
                            .padding(.vertical, 3)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "CFD7DE"))
                            .background(.white)
                            .cornerRadius(6)
                        
                        Text("주 \(group.selectedDaysCount)회")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.vertical, 3)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "CFD7DE"))
                            .background(.white)
                            .cornerRadius(6)
                    } // HStack
                } // VStack
                Spacer()
                
                Button {
                    // 습관 인증 템플릿 연결
                } label: {
                    
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 78)
                        .foregroundColor(Color(hex: "DBE1E7"))
                    
                } // Button
            } // HStack
            
            
            Divider()
            
            HStack {
                Text("개인 달성률 58%")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "8691A2"))
                Spacer()
                
                // 참여자 아바타들
                HStack(spacing: -8) {
                    ForEach(Array(group.partners.prefix(3)), id: \.self) { partner in
                        Circle()
                            .fill(Color(hex: "40444B"))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "person")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    if group.partners.count > 3 {
                        Circle()
                            .fill(Color(hex: "8691A2"))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("+\(group.partners.count - 3)")
                                    .font(.system(size: 8, weight: .medium))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .padding(16)
        .background(Color(hex: "F8F9FA"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E9ECEF"), lineWidth: 1)
        )
    }
}
