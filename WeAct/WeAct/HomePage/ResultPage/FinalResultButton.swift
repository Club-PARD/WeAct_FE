//
//  FinalResultButton.swift
//  WeAct
//
//  Created by 현승훈 on 7/1/25.
//

import SwiftUI

struct FinalResultButton: View {
    var body: some View {
        NavigationLink(destination: FinalResultPage_Rank1()) {
            Text("최종 결과가 도착했어요✨")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
                .background(Color(.darkGray))
                .clipShape(Capsule())
        }
    }
}
