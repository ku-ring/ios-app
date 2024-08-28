//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import ColorSet
import Translation
import ComposableArchitecture

public struct NoticeRow: View {
    let rowType: NoticeRowType
    let notice: Notice
    
    /// 번역 노출 여부
    @State var showsTranslation: Bool = false
    @AppStorage("com.kuring.service.lelabo.translation") private var transltationValue: Bool = false
    
    public init(
        notice: Notice,
        bookmarked: Bool = false,
        rowType: NoticeRowType? = nil
    ) {
        self.notice = notice

        if let rowType {
            self.rowType = rowType
            return
        }
        
        if notice.important {
            if bookmarked { self.rowType = .importantAndBookmark }
            else { self.rowType = .important }
        } else {
            if bookmarked { self.rowType = .bookmark }
            else { self.rowType = .none }
        }
    }

    public enum NoticeRowType {
        /// 중요이면서 북마크
        case importantAndBookmark
        /// 중요
        case important
        /// 북마크
        case bookmark
        /// 기본
        case none
    }
    
    public var body: some View {
        ZStack {
            switch rowType {
            case .important, .importantAndBookmark:
                Color.Kuring.primary.opacity(0.1)
                    .ignoresSafeArea()
            default:
                Color.clear
            }

            switch rowType {
            case .importantAndBookmark:
                ZStack {
                    HStack(alignment: .top, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            importantTagView
                            titleView
                            dateView
                        }
                        Spacer()
                        
                        translationButton
                    }
                    .padding(.top, 13)
                    
                    VStack {
                        HStack {
                            Spacer()
                            bookmarkView
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
            case .important:
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        importantTagView
                        titleView
                        dateView
                    }
                    Spacer()
                    
                    translationButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 13)
                .padding(.bottom, 16)
                
            case .bookmark:
                ZStack {
                    HStack(alignment: .top, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            titleView
                            dateView
                        }
                        Spacer()
                        
                        translationButton
                    }
                    .padding(.top, 16)
                    
                    VStack {
                        HStack {
                            Spacer()
                            bookmarkView
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
            case .none:
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        titleView
                        dateView
                    }
                    Spacer()
                    
                    translationButton
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }

    private var importantTagView: some View {
        Text("중요")
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.top, 4)
            .padding(.bottom, 6)
            .foregroundStyle(Color.Kuring.primary)
            .background(.clear)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.25)
                    .stroke(Color.Kuring.primary, lineWidth: 0.5)
            )
    }

    private var titleView: some View {
        Text(notice.subject)
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(Color.Kuring.body)
            .lineSpacing(7)
    }

    private var dateView: some View {
        // TODO: - 정보 재구성
        Text(separateWithDot(notice.postedDate))
            .font(.system(size: 14))
            .foregroundStyle(Color.Kuring.caption1)
            .padding(.top, 4)
    }

    private var bookmarkView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .compositingGroup()
                .foregroundStyle(Color.Kuring.primary)
                .frame(width: 16, height: 21)

            RoundedRectangle(cornerRadius: 2)
                .rotation(.degrees(45))
                .frame(width: 16, height: 16)
                .offset(x: 0, y: 14.5)
                .foregroundStyle(Color.red)
                .blendMode(.destinationOut)
        }
        .compositingGroup()
    }
    
    @ViewBuilder
    private var translationButton: some View {
        VStack {
            Spacer()
            if #available(iOS 17.4, *),
               transltationValue {
                Image(systemName: "translate")
                    .frame(width: 24)
                    .onTapGesture {
                        showsTranslation.toggle()
                    }
                    .translationPresentation(
                        isPresented: $showsTranslation,
                        text: notice.subject
                    )
            } else {
                EmptyView()
            }
            Spacer()
        }
    }
    
    private func separateWithDot(_ value: String) -> String {
        return value.replacingOccurrences(of: "-", with: ".")
    }
    
}

#Preview {
    List {
        NoticeRow(notice: .random, rowType: .important)
            .listRowInsets(EdgeInsets())
        NoticeRow(notice: .random, bookmarked: true, rowType: .importantAndBookmark)
            .listRowInsets(EdgeInsets())
        NoticeRow(notice: .random)
            .listRowInsets(EdgeInsets())
        NoticeRow(notice: .random, bookmarked: true)
            .listRowInsets(EdgeInsets())
    }
    .listStyle(.plain)
}
