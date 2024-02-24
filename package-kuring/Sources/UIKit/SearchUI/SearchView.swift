//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import SwiftUI
import ColorSet
import NoticeFeatures
import SearchFeatures
import ComposableArchitecture

/// TODO 모습은 다음과 같다.
/// ```swift
/// SearchList { result in
///     switch result {
///     case .notices(let notices):
///         // 공지 결과 리스트
///     case .staffs(let staffs):
///         // 스태프 결과 리스트
///     }
/// }
/// ```
public struct SearchView: View {
    @Bindable var store: StoreOf<SearchFeature>
    @FocusState var focus: SearchFeature.State.Field?

    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                /// 검색창
                HStack(alignment: .center, spacing: 12) {
                    /// 검색 아이콘
                    Image(systemName: "magnifyingglass")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.caption1.opacity(0.6))

                    TextField("검색어를 입력해주세요", text: $store.searchInfo.text)
                        .focused($focus, equals: .search)
                        .autocorrectionDisabled()
                        .onSubmit { store.send(.search) }

                    if store.searchInfo.searchPhase == .searching {
                        /// 검색 중 로딩 인디케이터
                        ProgressView()
                    } else {
                        if !store.searchInfo.text.isEmpty {
                            /// 검색어 삭제 버튼
                            Button {
                                store.send(.clearKeywordButtonTapped)
                            } label: {
                                Image(systemName: "xmark")
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(Color.caption1.opacity(0.6))
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                .cornerRadius(20)
            }

            if !store.recents.isEmpty {
                HStack {
                    /// 최근 검색어
                    Text("최근검색어")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.caption1.opacity(0.6))

                    Spacer()

                    /// 전체 삭제
                    Button {
                        store.send(.deleteAllRecentsButtonTapped)
                    } label: {
                        Text("전체삭제")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.caption1)
                            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 12)

                /// 최근 검색어 목록
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(store.recents, id: \.self) { recent in
                            HStack(alignment: .center, spacing: 6) {
                                Button {
                                    store.send(.recentSearchKeywordTapped(recent))
                                } label: {
                                    Text(recent)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.accentColor)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.accentColor.opacity(0.1))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .frame(height: 30)
            }

            HStack {
                Text("검색결과")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.caption1.opacity(0.6))
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                Spacer()
            }

            /// 검색타입 세그먼트
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                .cornerRadius(10)
                .overlay {
                    HStack {
                        Button {
                            store.send(.selectSearchType(.notice))
                        } label: {
                            SegmentView("공지", isSelect: store.searchInfo.searchType == .notice)
                        }

                        Button {
                            store.send(.selectSearchType(.staff))
                        } label: {
                            SegmentView("교직원", isSelect: store.searchInfo.searchType == .staff)
                        }
                    }
                    .padding(5)
                }

            /// 검색결과
            switch store.searchInfo.searchType {
            case .notice:
                if let notices = store.resultNotices, !notices.isEmpty {
                    List(notices, id: \.self) { notice in
                        NavigationLink(
                            state: NoticeAppFeature.Path.State.detail(
                                NoticeDetailFeature.State(notice: notice)
                            )
                        ) {
                            VStack(alignment: .leading) {
                                Text(notice.subject)

                                HStack {
                                    Text(notice.postedDate)

                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    beforePhaseView
                }
            case .staff:
                if let staffs = store.resultStaffs, !staffs.isEmpty {
                    List(staffs, id: \.self) { staff in
                        Button {
                            store.send(.staffRowSelected(staff))
                        } label: {
                            StaffRow(staff: staff)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                } else {
                    beforePhaseView
                }
            }
        }
        .padding(.horizontal, 20)
        .bind($store.focus, to: $focus)
        .sheet(
            item: $store.scope(
                state: \.staffDetail,
                action: \.staffDetail
            )
        ) { store in
            StaffDetailView(store: store)
                .presentationDetents([.medium])
        }
    }

    @ViewBuilder
    private func SegmentView(_ title: String, isSelect: Bool) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(isSelect ? .white : .clear)
            .shadow(
                color: .black.opacity(isSelect ? 0.1 : 0),
                radius: 6, x: 0, y: 0
            )
            .overlay {
                Text(title)
                    .font(.system(size: 16, weight: isSelect ? .bold : .medium))
                    .foregroundStyle(
                        isSelect
                            ? Color.accentColor
                            : Color.caption1.opacity(0.6)
                    )
            }
    }

    @ViewBuilder
    private var beforePhaseView: some View {
        VStack {
            Group {
                Text("검색 결과가 없어요")
            }
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
            .font(.system(size: 16))

            Spacer()
        }
        .padding(.top, 72)
    }

    public init(store: StoreOf<SearchFeature>) {
        self.store = store
    }
}

#Preview {
    NavigationStack {
        SearchView(
            store: Store(
                initialState: SearchFeature.State(recents: ["방학", "운송수단", "운임표"]),
                reducer: { SearchFeature() }
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search View")
    }
}
