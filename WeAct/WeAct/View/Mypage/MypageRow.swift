//
//  ContentView.swift
//  WeAct
//
//  Created by 현승훈 on 6/30/25.
//

import SwiftUI

struct MypageRow: View {
    var text: String

    var body: some View {
        HStack {
            Text(text)
                .font(.custom("Pretendard", size: 16))
                .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MypageRow(text:"Hi")
}

