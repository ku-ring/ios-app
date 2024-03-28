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
            /// 검색창
            HStack(alignment: .center, spacing: 12) {
                /// 검색 아이콘
                Image(systemName: "magnifyingglass")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.Kuring.gray300)
                
                TextField("공지 제목 또는 교수명을 입력해주세요.", text: $store.searchInfo.text)
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
                                .foregroundStyle(Color.Kuring.gray300)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            .background(Color.Kuring.gray100)
            .cornerRadius(20)
            .padding(.horizontal, 20)

            if !store.recents.isEmpty {
                HStack {
                    /// 최근 검색어
                    Text("최근검색어")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.Kuring.caption1)

                    Spacer()

                    /// 전체 삭제
                    Button {
                        store.send(.deleteAllRecentsButtonTapped)
                    } label: {
                        Text("전체삭제")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.Kuring.caption1)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 12)
                .padding(.horizontal, 20)

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
                                        .foregroundStyle(Color.Kuring.primary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.Kuring.primary.opacity(0.1))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .frame(height: 30)
                .padding(.horizontal, 20)
            }

            HStack {
                Text("검색결과")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                Spacer()
            }
            .padding(.horizontal, 20)

            /// 검색타입 세그먼트
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .background(Color.Kuring.gray100)
                .cornerRadius(10)
                .overlay {
                    HStack {
                        Button {
                            store.send(.selectSearchType(.notice))
                        } label: {
                            segmentView("공지", isSelect: store.searchInfo.searchType == .notice)
                        }
                        
                        Button {
                            store.send(.selectSearchType(.staff))
                        } label: {
                            segmentView("교직원", isSelect: store.searchInfo.searchType == .staff)
                        }
                    }
                    .padding(5)
                }
            
                .padding(.horizontal, 20)

            /// 검색결과
            switch store.searchInfo.searchType {
            case .notice:
                if let notices = store.resultNotices, !notices.isEmpty {
                    List(notices, id: \.self) { notice in
                        VStack(spacing: 0) {
                            ZStack {
                                NavigationLink(
                                    state: NoticeAppFeature.Path.State.detail(
                                        NoticeDetailFeature.State(notice: notice)
                                    )
                                ) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(notice.subject)
                                        .font(.system(size: 15))
                                        .foregroundStyle(Color.Kuring.title)
                                    
                                    HStack {
                                        Text(notice.postedDate)
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.Kuring.caption1)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 22)
                            
                            Divider()
                                .frame(height: 0.25)
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .background(Color.Kuring.bg)
                    }
                    .listStyle(.plain)
                    .listRowBackground(Color.Kuring.bg)
                } else {
                    beforePhaseView
                }
            case .staff:
                if let staffs = store.resultStaffs, !staffs.isEmpty {
                    List(staffs, id: \.self) { staff in
                        VStack(spacing: 0) {
                            Button {
                                store.send(.staffRowSelected(staff))
                            } label: {
                                StaffRow(staff: staff)
                            }
                            .buttonStyle(.plain)

                            Divider()
                                .frame(height: 0.25)
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .background(Color.Kuring.bg)
                    }
                    .listStyle(.plain)
                    .listRowBackground(Color.Kuring.bg)
                } else {
                    beforePhaseView
                }
            }
        }
        .background(Color.Kuring.bg)
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

    private func segmentView(_ title: String, isSelect: Bool) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(isSelect ? Color.Kuring.bg : .clear)
            .shadow(
                color: .black.opacity(isSelect ? 0.1 : 0),
                radius: 6, x: 0, y: 0
            )
            .overlay {
                Text(title)
                    .font(.system(size: 16, weight: isSelect ? .bold : .medium))
                    .foregroundStyle(
                        isSelect
                        ? Color.Kuring.primary
                        : Color.Kuring.caption1
                    )
            }
    }

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
