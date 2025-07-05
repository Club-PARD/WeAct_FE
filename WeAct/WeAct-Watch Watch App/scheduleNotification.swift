//
//  scheduleNotification.swift
//  WeAct
//
//  Created by 현승훈 on 7/4/25.
//


import UserNotifications

func scheduleNotification(for weekdays: [Int], at hour: Int, minute: Int) {
    let center = UNUserNotificationCenter.current()
    
    for weekday in weekdays {
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday  // 1: Sunday ~ 7: Saturday
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "습관 알림"
        content.body = "오늘 습관을 실천할 시간이에요!"
        content.sound = .default
        
        let id = "habit-\(weekday)"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        center.add(request)
    }
}
