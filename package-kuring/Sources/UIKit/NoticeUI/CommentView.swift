//
//  CommentView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/1/25.
//

import SwiftUI
import ColorSet

/// 댓글 전체 영역, sheet 형식으로 띄워줌
/// ```swift
///  CommentView()
/// ```
struct CommentView: View {
    @State var text: String = ""
    @State private var textViewHeight: CGFloat = 40
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                VStack {
                    Text("댓글")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.Kuring.title)
                    
                    comment
                    comment
                    comment
                }
            }
            
            HStack(spacing: 12) {
                CommentTextField(text: $text, calculatedHeight: $textViewHeight)
                    .frame(height: textViewHeight)
                
                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 40, height: 40)
                    .overlay(alignment: .center) {
                        Image("arrow_up", bundle: .module)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .background(Color.Kuring.bg)
        }
        .padding(.top, 20)
        .padding(.bottom, 14)
    }
    
    private var comment: some View {
        VStack {
            Divider()
                .frame(height: 2)
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Image("user", bundle: .module)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("쿠링")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                    
                    Spacer()
                    
                    Image("comment_circle", bundle: .module)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Menu {
                        Button {
                            
                        } label: {
                            Label {
                                Text("신고하기")
                            } icon: {
                                Image("siren", bundle: .module)
                            }
                        }
                        
                        Button(role: .destructive) {
                            
                        } label: {
                            Label("삭제하기", systemImage: "trash")
                        }
                    } label: {
                        Image("more_vertical", bundle: .module)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .menuStyle(.borderlessButton) 
                }
                
                Text("쿠링 댓글 예시용\n쿠링 댓글 예시용\n쿠링 댓글 예시용")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.gray400)
                
                Text("\(dateString(date: Date()))")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
        }
    }
    
    // temporary helper func
    private func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH : mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: date)
    }
}

#Preview {
    CommentView()
}
