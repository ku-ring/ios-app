//
//  SwiftUIView.swift
//  
//
//  Created by 🏝️ GeonWoo Lee on 10/2/23.
//

import Model
import SwiftUI
import ColorSet

public struct NoticeRow: View {
    let rowType: NoticeRowType
    let notice: Notice

    public init(_ rowType: NoticeRowType, notice: Notice) {
        self.rowType = rowType
        self.notice = notice
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
                ColorSet.green.opacity(0.1)
            default:
                Color.clear
            }

            switch rowType {
            case .importantAndBookmark:
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        VStack(spacing: 0) {
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
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        importantTagView
                        titleView
                        dateView
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    Spacer()
                }
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
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        titleView
                        dateView
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    Spacer()
                }
                
            }
        }
        .listRowInsets(EdgeInsets())
    }

    @ViewBuilder
    private var importantTagView: some View {
        Text("중요")
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(ColorSet.Label.green)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.25)
                    .stroke(ColorSet.green, lineWidth: 0.5)
            )
    }

    @ViewBuilder
    private var titleView: some View {
        Text(notice.subject)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(ColorSet.Label.gray)
    }

    @ViewBuilder
    private var dateView: some View {
        Text(notice.postedDate)
            .font(.system(size: 14))
            .foregroundStyle(ColorSet.Label.gray.opacity(0.6))
    }

    @ViewBuilder
    private var bookmarkView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .compositingGroup()
                .foregroundStyle(ColorSet.green)
                .frame(width: 16, height: 21)

            RoundedRectangle(cornerRadius: 2)
                .rotation(.degrees(45))
                .frame(width: 16, height: 16)
                .offset(x: 0, y: 14.5)
                .blendMode(.destinationOut)
        }
        .compositingGroup()
    }
}

#Preview {
    List {
        NoticeRow(.importantAndBookmark, notice: .random)
        NoticeRow(.important, notice: .random)
        NoticeRow(.bookmark, notice: .random)
        NoticeRow(.none, notice: .random)
    }
    .listStyle(.plain)
}
