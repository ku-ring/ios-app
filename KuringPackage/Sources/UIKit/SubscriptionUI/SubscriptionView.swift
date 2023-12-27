import SwiftUI
import DepartmentFeatures
import SubscriptionFeatures
import ComposableArchitecture

struct SubscriptionView: View {
    @Bindable var store: StoreOf<SubscriptionFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("알림 받고 싶은 \n카테고리를 선택해주세요")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.12, blue: 0.15))
            }
            .padding(.top, 32)
            .padding(.bottom, 60)
            
            // TODO: 디자인 시스템 분리 - 칩 (Search 랑 합쳐서 KuringPicker) 같은거 있으면 좋을 것 같아요.
            /// 일반 / 학과 카테고리 세그먼트
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                Button {
                    store.send(.segmentSelected(.university))
                } label: {
                    SubscriptionSegment(
                        title: "일반 카테고리",
                        isSelected: store.subscriptionType == .university
                    )
                }
                
                Button {
                    store.send(.segmentSelected(.department))
                } label: {
                    SubscriptionSegment(
                        title: "학과 카테고리",
                        isSelected: store.subscriptionType == .department
                    )
                }
            }
            .padding(.bottom, 33)
            
            // TODO: TCA 하위 도메인으로 분리 + 뷰 분리
            /// 카테고리 목록
            switch store.subscriptionType {
            case .university:
                /// 일반 카테고리 목록
                VStack {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                        ForEach(store.univNoticeTypes) { univNoticeType in
                            let isSelected = store.selectedUnivNoticeType.contains(univNoticeType)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 1)
                                    .stroke(
                                        isSelected ? Color.accentColor : Color.clear,
                                        lineWidth: isSelected ? 2 : 0
                                    )
                                    .background(
                                        isSelected
                                        ? Color.accentColor.opacity(0.1)
                                        : Color.black.opacity(0.03)
                                    )
                                
                                VStack {
                                    Image(univNoticeType.name, bundle: Bundle.subscriptions)
                                    
                                    Text(univNoticeType.korName)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(
                                            isSelected
                                            ? Color.accentColor
                                            : Color(red: 0.32, green: 0.32, blue: 0.32)
                                        )
                                }
                                .padding()
                            }
                            .onTapGesture {
                                store.send(.univNoticeTypeSelected(univNoticeType))
                            }
                            
                        }
                    }
                    Spacer()
                }
                
            case .department:
                /// 빈 페이지 (내 학과 목록이 없을 때)
                if store.myDepartments.isEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text("아직 추가된 학과가 없어요.\n관심 학과를 추가하고 공지를 확인해 보세요!")
                                .font(.system(size: 16, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color(red: 0.68, green: 0.69, blue: 0.71))
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                } else {
                    /// 학과 카테고리 리스트
                    VStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            ForEach(store.myDepartments) { department in
                                let isSelected = store.selectedDepartment.contains(department)
                                
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(department.korName)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(isSelected ? Color.accentColor : Color.black.opacity(0.1))
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.horizontal, 21.5)
                                    .padding(.top, store.myDepartments.first == department ? 22 : 0)
                                    .padding(.bottom, store.myDepartments.last == department ? 22 : 0)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        store.send(.departmentSelected(department))
                                    }
                                    
                                    // 밑줄
                                    if store.myDepartments.last != department {
                                        Rectangle()
                                            .frame(height: 0.5)
                                            .foregroundStyle(.black.opacity(0.1))
                                            .padding(.top, 16)
                                            .padding(.bottom, 16)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(Color.black.opacity(0.03))
                            )
                        }
                    }
                }
                
                // TODO: 디자인 시스템 분리 - 상단에 블러가 존재하는 버튼
                /// 학과 추가/편집하기 버튼 - `DepartmentEditor` 로 이동
                NavigationLink(
                    state: SubscriptionAppFeature.Path.State.departmentEditor(
                        // TODO: init parameter 수정 (현재는 테스트용)
                        DepartmentEditorFeature.State(
                            myDepartments: store.myDepartments
                        )
                    )
                ) {
                    HStack(alignment: .center, spacing: 10) {
                        Spacer()
                        
                        Text(store.myDepartments.isEmpty ? "학과 추가하기" : "학과 편집하기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
                    .frame(height: 50, alignment: .center)
                    .background(Color.accentColor)
                    .cornerRadius(100)
                    .background {
                        LinearGradient(
                            gradient: Gradient(colors: [.white.opacity(0.1), .white]),
                            startPoint: .top, endPoint: .bottom
                        )
                        .offset(x: 0, y: -32)
                    }
                }
            }
            
            
        }
        .padding(.horizontal, 20)
        // TODO: TCA에 따라 외부에서 구현
        .navigationTitle("푸시 알림 설정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if store.isWaitingResponse {
                ProgressView()
            } else {
                Button("완료") {
                    store.send(.confirmButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionView(
            store: Store(
                initialState: SubscriptionFeature.State(),
                reducer: { SubscriptionFeature() }
            )
        )
    }
}
