//
//  ToastView.swift
//  WeAct
//
//  Created by 주현아 on 7/3/25.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
            Text(message)
                .foregroundColor(.white)
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.medium)
                )
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .background(Color(red: 0.27, green: 0.27, blue: 0.27))
        .cornerRadius(10)
        .padding(.bottom, 30)
        
    }
}
