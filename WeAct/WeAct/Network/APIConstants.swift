import Foundation

struct APIConstants {
    static let baseURL = "https://naruto.asia"
    
    //auth-controller의 login포함
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
    
    struct Room {
        static let create = "/room"                           // 방 생성 (POST)
        static let oneDayCount = "/room/oneDayCount"          // 일일 카운트 조회
        static let home = "/room/home"                        // + /{roomId}
        static let finalRanking = "/room/finalRanking"        // + /{roomId}
        static let checkThreeDay = "/room/checkThreeDay"      // + /{roomId},
        static let checkPoint = "/room/checkPoint"            // + /{roomId}
        static let checkDays = "/room/checkDays"              // + /{roomId}
        static let celebration = "/room/celebration"              // + /{roomId}
    }
    
    struct Like {
          static let create = "/like"                           // 좋아요 (POST)
      }
    
    struct HabitPost {
        static let getAll = "/habit-post"                     // 전체 습관 인증 조회
        static let getOne = "/habit-post/one"                 // 단일 습관 인증
        static let create = "/habit-post"                     // 습관 인증 업로드
    }
    
    struct Comment {
        static let create = "/comments" // 댓글 생성
    }
    
    struct MemberInformation {
        static let exit = "/member/exit"           // + /{roomId}
        static let hamburger = "/member/hamburger"           // + /{roomId}
        static let habitAndRemindTime = "/member/habitAndRemindTime"
    }
    
    struct UserInvite {
        static let respond = "/invite"                         // PATCH
    }
    
    struct InAppNotification {
        static let getNotification = "/inAppNotification/getNotification"
    }
}
