//
//  AcademicScheduleSheet.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/23/25.
//

import SwiftUI
import ColorSet

/// 주요 학사 일정을 한번에 보여주는 바텀시트 뷰
/// 높이는 **280**으로 사용
/// ```swift
///    .sheet(isPresented: $isPresented) {
///        AcademicScheduleSheet(
///            schedules: schedules,
///            isPresented: $isPresented
///        )
///        .presentationDetents([.height(280)])
///        .presentationCornerRadius(20)
///        .presentationDragIndicator(.visible)
///    }
/// ```
///  - Parameters:
///    - schedules: 보여줄 학사 일정들
///    - isPresented: 바텀시트 노출 여부
struct AcademicScheduleSheet: View {
    let schedules: [ScheduleItem]
    @State var currentPage: Int = 0
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text("이번 주 예정된 학사일정을 확인해보아요")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.Kuring.title)
                .padding(.top, 24)

            TabView(selection: $currentPage) {
                ForEach(schedules.indices, id: \.self) { index in
                    ScheduleCard(schedule: schedules[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, 16)
            
            HStack(spacing: 8) {
                ForEach(schedules.indices, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.Kuring.primary : Color.Kuring.primary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .padding(.top, 24)
            
            Button(action: {
                isPresented = false
            }) {
                Text("학사일정 전체 확인하기 >")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.Kuring.bg)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        Capsule()
                            .fill(Color.Kuring.primary)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .padding(.top, 24)
        }
    }
}

/// 학사 일정 바텀시트에 사용되는 하나의 학사 일정 카드
/// ```swift
///    ScheduleCard(schedule: schedules[index])
/// ```
///  - Parameters:
///    - schedule: 보여줄 학사 일정
struct ScheduleCard: View {
    let schedule: ScheduleItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(schedule.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color.Kuring.title)
            
            Text(schedule.date)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.Kuring.caption1)
        }
        .frame(maxHeight: 60)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.Kuring.primarySelected)
        )
        .padding(.horizontal, 20)
    }
}

struct ScheduleItem {
    let title: String
    let date: String
}

#Preview {
    @Previewable @State var currentPage = 0
    @Previewable @State var isPresented = false
    
    let schedules = [
        ScheduleItem(title: "학사일정 text", date: "8. 04 (월) 오전 9:30 - 8. 05 (화) 오후 5:00"),
        ScheduleItem(title: "학사일정 text", date: "8. 06 (수) 오전 10:00 - 8. 07 (목) 오후 3:00"),
        ScheduleItem(title: "학사일정 text", date: "8. 08 (금) 오전 11:00 - 8. 09 (토) 오후 4:00")
    ]
    
    VStack {
        Button("Show Schedule") {
            isPresented = true
        }
        .padding()
    }
    .sheet(isPresented: $isPresented) {
        AcademicScheduleSheet(
            schedules: schedules,
            isPresented: $isPresented
        )
        .presentationDetents([.height(280)])
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
}
