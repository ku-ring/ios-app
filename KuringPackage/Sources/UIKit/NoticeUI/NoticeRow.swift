import Models
import SwiftUI

public struct NoticeRow: View {
    var rowType: NoticeRowType
    let notice: Notice
    
    public init(notice: Notice) {
        self.notice = notice
        
        var bookmarkedNotices = [Notice]()
        let isBookmark: Bool = bookmarkedNotices.contains(notice)
        if notice.important {
            if isBookmark { self.rowType = .importantAndBookmark }
            else { self.rowType = .important }
        } else {
            if isBookmark { self.rowType = .bookmark }
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
                Color(red: 0.24, green: 0.74, blue: 0.5, opacity: 0.1)
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
                VStack(alignment: .leading, spacing: 4) {
                    importantTagView
                    titleView
                    dateView
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
                HStack {
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
            .foregroundStyle(Color(red: 0.24, green: 0.74, blue: 0.5))
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.25)
                    .stroke(Color(red: 0.24, green: 0.74, blue: 0.5), lineWidth: 0.5)
            )
    }
    
    @ViewBuilder
    private var titleView: some View {
        Text(notice.subject)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(Color(red: 0.21, green: 0.24, blue: 0.29))
    }
    
    @ViewBuilder
    private var dateView: some View {
        // TODO: - 정보 재구성
        Text(notice.postedDate)
            .font(.system(size: 14))
            .foregroundStyle(Color(red: 0.21, green: 0.24, blue: 0.29).opacity(0.6))
    }
    
    @ViewBuilder
    private var bookmarkView: some View {
        // TODO: 디자인 시스템 분리 - 북마크
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .compositingGroup()
                .foregroundStyle(Color(red: 0.24, green: 0.74, blue: 0.5))
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
