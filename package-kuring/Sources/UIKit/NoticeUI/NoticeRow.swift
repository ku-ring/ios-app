//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Caches
import Models
import SwiftUI
import ColorSet
import ComposableArchitecture

public struct NoticeRow: View {
    var rowType: NoticeRowType
    let notice: Notice

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
                ColorSet.primary.opacity(0.1)
                    .ignoresSafeArea()
            default:
                Color.clear
            }

            switch rowType {
            case .importantAndBookmark:
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        VStack {
                            importantTagView
                                .padding(.top, 12)
                        }
                        Spacer()
                        bookmarkView
                    }
                    titleView
                    dateView
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            case .important:
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        importantTagView
                        titleView
                        dateView
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            case .bookmark:
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 0) {
                        VStack {
                            titleView
                                .padding(.top, 12)
                        }
                        Spacer()
                        bookmarkView
                    }
                    dateView
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            case .none:
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        titleView
                        dateView
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
    }

    @ViewBuilder
    private var importantTagView: some View {
        Text("중요")
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(ColorSet.primary)
            .background(ColorSet.bg)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.25)
                    .stroke(ColorSet.primary, lineWidth: 0.5)
            )
    }

    @ViewBuilder
    private var titleView: some View {
        Text(notice.subject)
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(ColorSet.body)
    }

    @ViewBuilder
    private var dateView: some View {
        // TODO: - 정보 재구성
        Text(notice.postedDate)
            .font(.system(size: 14))
            .foregroundStyle(ColorSet.caption1)
    }

    @ViewBuilder
    private var bookmarkView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .compositingGroup()
                .foregroundStyle(Color.accentColor)
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
}

#Preview {
    List {
        NoticeRow(notice: .random)
            .listRowInsets(EdgeInsets())
        NoticeRow(notice: .random)
            .listRowInsets(EdgeInsets())
        NoticeRow(notice: .random)
            .listRowInsets(EdgeInsets())
        NoticeRow(notice: .random)
            .listRowInsets(EdgeInsets())
    }
    .listStyle(.plain)
}
