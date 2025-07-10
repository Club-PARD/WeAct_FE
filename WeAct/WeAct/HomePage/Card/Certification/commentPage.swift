//
//  CommentPage.swift
//  WeAct
//
//  Created by 현승훈 on 7/8/25.
//
import SwiftUI

struct Comment: Identifiable, Hashable, Codable {
    let id: UUID
    let text: String
    let date: Date
    
    init(id: UUID = UUID(), text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
}

struct CommentPage: View {
    @Binding var isFlipped: Bool
    @State private var commentText = ""
    @State private var comments: [Comment] = []
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool  // ✅ 키보드 감지
    
    var body: some View {
        VStack(spacing: 0) {
            // ✅ 카드 (댓글 영역)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 280, height: 452)
                .overlay(
                    VStack(spacing: 0) {
                        // 상단 바 (타이틀 + 닫기 버튼)
                        HStack {
                            Text("댓글")
                                .font(.custom("Pretendard-Bold", size: 18))
                                .padding(.leading)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isFlipped = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .padding()
                            }
                        }
                        .padding(.top, 10)
                        
                        // 댓글 리스트
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(comments) { comment in
                                    HStack(alignment: .top, spacing: 10) {
                                        Image("BasicProfile")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text("이주원")
                                                    .font(.custom("Pretendard-Bold", size: 14))
                                                Text(relativeTimeString(from: comment.date))
                                                    .font(.custom("Pretendard-Medium", size: 12))
                                                    .foregroundColor(.gray)
                                            }
                                            Text(comment.text)
                                                .font(.custom("Pretendard-Medium", size: 14))
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        // 댓글 입력창
                        ZStack {
                            TextField("댓글을 입력하세요", text: $commentText)
                                .padding(10)
                                .background(Color(hex: "F7F7F7"))
                                .cornerRadius(8)
                                .frame(width: 252, height: 44)
                                .focused($isTextFieldFocused)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    if !commentText.trimmingCharacters(in: .whitespaces).isEmpty {
                                        let newComment = Comment(text: commentText, date: Date())
                                        comments.append(newComment)
                                        saveComments()
                                        commentText = ""
                                    }
                                }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color(hex: "FF4B2F"))
                                }
                                .padding(.trailing, 26)
                                .disabled(commentText.trimmingCharacters(in: .whitespaces).isEmpty)  // ✅ 비활성화
                                .opacity(commentText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.3 : 1)  // ✅ 흐리게
                            }
                        }
                        .padding(.bottom, 14)
                    }
                )
            
            // ✅ 카드 밖 버튼 (사진 보기) - 키보드 올라오면 비활성화
            Spacer().frame(height: 53)
            Button(action: {
                withAnimation {
                    isFlipped = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        dismiss()
                    }
                }
            }) {
                HStack {
                    Image("album")
                    Text("사진보기")
                }
            }
            .foregroundColor(.white)
            .frame(width: 118, height: 48)
            .background(Color(hex: "464646"))
            .cornerRadius(24)
            .disabled(isTextFieldFocused)  // ✅ 비활성화
            .opacity(isTextFieldFocused ? 0.3 : 1)  // ✅ 흐리게
        }
        .onAppear {
            loadComments()
        }
    }
    
    func relativeTimeString(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 {
            return "\(seconds)초 전"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)분 전"
        } else {
            let hours = seconds / 3600
            return "\(hours)시간 전"
        }
    }
    
    func saveComments() {
        if let data = try? JSONEncoder().encode(comments) {
            UserDefaults.standard.set(data, forKey: "savedComments")
        }
    }
    
    func loadComments() {
        if let data = UserDefaults.standard.data(forKey: "savedComments"),
           let decoded = try? JSONDecoder().decode([Comment].self, from: data) {
            comments = decoded
        }
    }
}
