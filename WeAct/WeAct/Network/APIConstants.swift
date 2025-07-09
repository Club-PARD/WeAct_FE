import Foundation

struct APIConstants {
    static let baseURL = "https://naruto.asia"
    
    struct User {
        static let checkDuplicate = "/user/checkDuplicated" // + /{userId}
        static let create = "/user/" // 회원가입
        static let login = "/auth/login" // 로그인
        static let profile = "/user/profile" // 사용자 프로필 조회
        static let update = "/user" // 사용자 정보 수정 (PATCH)
        static let delete = "/user" // 사용자 탈퇴 (DELETE)
        static let userInfo = "/user/" // 사용자 정보 조회 (GET)
        static let search = "/user/search" // + /{userId} - 사용자 검색
        static let addFriend = "/user/search/add" // + /{userId} - 친구 추가
        static let home = "/user/home" // 홈 정보 조회
        static let profilePhoto = "/user/profile-photo" // 프로필 사진 업로드
    }
    
    struct Auth {
        static let login = "/auth/login" // 로그인
        static let refresh = "/auth/refresh" // 토큰 갱신 (필요시)
        static let logout = "/auth/logout" // 로그아웃 (필요시)
    }
    
    struct Group {
        static let create = "/group" // 그룹 생성
        static let search = "/group/search" // 그룹 검색
        static let detail = "/group" // + /{groupId} - 그룹 상세
        static let join = "/group/join" // 그룹 가입
        static let leave = "/group/leave" // 그룹 탈퇴
        static let update = "/group" // 그룹 정보 수정
        static let delete = "/group" // 그룹 삭제
    }
    
    struct Comment {
        static let create = "/comment" // 댓글 생성
        static let list = "/comment" // 댓글 목록
        static let update = "/comment" // 댓글 수정
        static let delete = "/comment" // 댓글 삭제
    }
    
    struct MemberInformation {
        static let base = "/member-information" // 멤버 정보 관련
    }
}
