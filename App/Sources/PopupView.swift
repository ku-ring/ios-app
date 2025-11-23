//
//  SwiftUIView.swift
//
//
//  Created by 최효원 on 8/1/24.
//

import SwiftUI
import ColorSet

struct PopupView: View {
  @State private var isPresented: Bool = true
  
  var body: some View {
    if isPresented {
      ZStack {
        Color.black.opacity(0.4)
          .edgesIgnoringSafeArea(.all)
        
        VStack(spacing: 0) {
          headerView
          footerView
        }
        .background(Color.gray)
        .cornerRadius(15)
        .frame(width: 280, height: 290)
      }
    }
  }
  
  private var headerView: some View {
    ZStack {
      Rectangle()
        .fill(Color.Kuring.primary)
      
      VStack(spacing: 0) {
        HStack {
          Spacer()
          closeButton
        }
        .padding(16)
        
        Image("Popup.icon")
          .padding(.bottom, 15)
        
        Text("쿠링 이용자분들의\n소중한 의견을 구합니다!")
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(Color.Kuring.gray100)
          .multilineTextAlignment(.center)
          .lineSpacing(3)
          .padding(.bottom, 12)
        
        infoView
          .padding(.bottom, 12)
      }
    }
    .frame(height: 230)
  }
  
  private var closeButton: some View {
    Button(action: {
      isPresented = false
    }) {
      Image(systemName: "xmark")
        .foregroundColor(Color.Kuring.gray100)
    }
  }
  
  private var infoView: some View {
    HStack(alignment: .center, spacing: 19) {
      infoItem(title: "참여대상", description: "건국대학교\n재학생 및 휴학생")
      infoItem(title: "설문조사 기간", description: "2024.07.30 ~\n 2024.08.05")
      infoItem(title: "설문조사 경품", description: "아이스 아메리카노\n기프티콘")
    }
    .padding(12)
    .frame(height: 56)
    .font(.system(size: 8))
    .background(
      RoundedRectangle(cornerRadius: 6)
        .fill(Color.Kuring.primarySelected)
        .opacity(0.3)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(Color.Kuring.primarySelected, lineWidth: 0.5)
        .opacity(0.6)
    )
  }
  
  private func infoItem(title: String, description: String) -> some View {
    VStack(spacing: 2) {
      Text(title).fontWeight(.semibold)
      Text(description)
        .multilineTextAlignment(.center)
    }
    .foregroundStyle(Color.Kuring.body)
  }
  
  private var footerView: some View {
    ZStack {
      Rectangle()
        .fill(Color.Kuring.bg)
      
      Button(action: {
        UserDefaults.standard.set(true, forKey: "hasParticipated")
        isPresented = false
        if let url = URL(string: "https://tally.so/r/npVg48") {
          UIApplication.shared.open(url)
        }
      }) {
        Text("설문 참여하러 가기")
          .foregroundStyle(Color.Kuring.primary)
          .font(.system(size: 16, weight: .semibold))
      }
    }
    .frame(height: 60)
  }
  
  
  /// 팝업 표시 여부 판단 함수
  static func checkShowPopup() -> Bool {
    let calendar = Calendar.current
    let currentDate = Date()
    
    /// 2024년 8월 6일 정각까지
    let targetDateComponents = DateComponents(year: 2024, month: 8, day: 6, hour: 0, minute: 0, second: 0)
    let targetDate = calendar.date(from: targetDateComponents) ?? Date()
    
    /// UserDefaults에서 참여 여부 확인
    let hasParticipated = UserDefaults.standard.bool(forKey: "hasParticipated")
    
    /// 현재 날짜가 목표 날짜 이전이고, 참여하지 않은 경우에만 팝업을 표시
    return currentDate < targetDate && !hasParticipated
  }
}

#Preview {
  PopupView()
}
