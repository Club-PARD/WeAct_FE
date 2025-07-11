import SwiftUI

struct PassComment: Identifiable, Hashable, Codable {
    let id: UUID
    let text: String
    let date: Date
    
    init(id: UUID = UUID(), text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
}

struct CommentPage_pass: View {
    @Binding var isPresented: Bool
    let onPhotoView: () -> Void
    
    @State private var commentText = ""
    @State private var comments: [PassComment] = []
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 280, height: 452)
                .overlay(
                    VStack(spacing: 0) {
                        // 상단 바
                        HStack {
                            Text("댓글")
                                .font(.custom("Pretendard-Bold", size: 18))
                                .padding(.leading)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isPresented = false
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
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    if !commentText.trimmingCharacters(in: .whitespaces).isEmpty {
                                        let newComment = PassComment(text: commentText, date: Date())
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
                            }
                        }
                        .padding(.bottom, 14)
                    }
                )
            
            // 사진 보기 버튼
            Spacer().frame(height: 30)
            Button(action: {
                withAnimation {
                    onPhotoView()  // ✅ 카드 뒤집기 (모달 유지)
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
        }
        .onAppear {
            loadComments()
        }
    }
    
    // 댓글 저장
    func saveComments() {
        if let data = try? JSONEncoder().encode(comments) {
            UserDefaults.standard.set(data, forKey: "savedPassComments")  // ✅ 패스카드용 저장소
        }
    }
    
    // 댓글 불러오기
    func loadComments() {
        if let data = UserDefaults.standard.data(forKey: "savedPassComments"),
           let decoded = try? JSONDecoder().decode([PassComment].self, from: data) {
            comments = decoded
        }
    }
    
    // 시간 표시
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
}
