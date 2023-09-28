//
//  SubscriptionView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/24.
//

import Model
import SwiftUI
import SubscriptionFeature
import ComposableArchitecture

struct SubscriptionFeature: Reducer {
    struct State: Equatable {
        var subscriptionType: SubscriptionType = .university
        
        /// 대학 공지 리스트
        let univNoticeTypes: [String] = ["학사", "취창업", "국제", "장학", "입학", "학생", "산학", "일반"]
        /// 대학 공지 리스트 중 내가 구독한 공지
        var selectedunivNoticeType: [String] = []
        
        /// 내가 추가한 공지 리스트
        var myDepartments: IdentifiedArrayOf<Department> = [.산업디자인학과, .전기전자공학부, .컴퓨터공학부, .건국대학교, .경제학과, .수의학과, .영문학과, .의생명공학과]
        /// 내가 추가한 공지 리스트 중 지금 선택한 학과
        var selectedDepartment: Department = Department.컴퓨터공학부
        
        enum SubscriptionType: Equatable {
            case university
            case department
        }
    }
    
    enum Action {
        case chipButtonTapped(State.SubscriptionType)
        
        case univNoticeTypeGridTapped(String)
        case departmentGridTapped(Department)
        case confirmButtonTapped
        case editDepartmentsButtonTapped
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .chipButtonTapped(let subscriptionType):
                state.subscriptionType = subscriptionType
                
                return .none
            case .univNoticeTypeGridTapped(let univNoticeType):
                if let index = state.selectedunivNoticeType.firstIndex(of: univNoticeType) {
                    state.selectedunivNoticeType.remove(at: index)
                } else {
                    state.selectedunivNoticeType.append(univNoticeType)
                }
                
                return .none
            case .departmentGridTapped(let department):
                state.selectedDepartment = department
                
                return .none
            case .confirmButtonTapped:
                
                return .none
            case .editDepartmentsButtonTapped:
                
                return .none
            }
        }
    }
}

struct SubscriptionView: View {
    let store: StoreOf<SubscriptionFeature>
    
    // TODO: 디자인 시스템 분리 - ColorSet
    struct Constants {
        static let kuringPrimary: Color = Color(red: 0.24, green: 0.74, blue: 0.5)
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Text("알림 받고 싶은 \n카테고리를 선택해주세요")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.15))
                }
                .padding(.top, 32)
                .padding(.bottom, 60)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                    // TODO: 디자인 시스템 분리 - 칩
                    VStack {
                        if viewStore.subscriptionType == .university {
                            didSelectChipView("일반 카테고리")
                        } else {
                            deSelectChipView("일반 카테고리")
                                .onTapGesture {
                                    viewStore.send(.chipButtonTapped(.university))
                                }
                        }
                    }
                    .font(.system(size: 16, weight: .bold))
                    
                    VStack {
                        if viewStore.subscriptionType == .department {
                            didSelectChipView("학과 카테고리")
                        } else {
                            deSelectChipView("학과 카테고리")
                                .onTapGesture {
                                    viewStore.send(.chipButtonTapped(.department))
                                }
                        }
                    }
                    .font(.system(size: 16, weight: .bold))
                }
                .padding(.bottom, 48)
                
                
                switch viewStore.subscriptionType {
                case .university:
                    VStack {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                            ForEach(viewStore.univNoticeTypes, id: \.self) { univNoticeType in
                                let isSelected = viewStore.selectedunivNoticeType.contains(univNoticeType)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .inset(by: 1)
                                        .stroke(isSelected ? Constants.kuringPrimary : Color.clear,
                                                lineWidth: isSelected ? 2 : 0)
                                        .background(isSelected ? Constants.kuringPrimary.opacity(0.1) : Color.black.opacity(0.03))
                                        
                                    VStack {
                                        Image(univNoticeType, bundle: Bundle.subscriptions)
                                        Text(univNoticeType)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(isSelected ? Constants.kuringPrimary : Color(red: 0.32, green: 0.32, blue: 0.32))
                                    }
                                    .padding()
                                }
                                .onTapGesture {
                                    viewStore.send(.univNoticeTypeGridTapped(univNoticeType))
                                }
                                
                            }
                        }
                        Spacer()
                    }
                case .department:
                    VStack {
                        if viewStore.myDepartments.isEmpty {
                            VStack(alignment: .center) {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("아직 추가된 학과가 없어요.\n관심 학과를 추가하고 공지를 확인해 보세요!")
                                        .font(.system(size: 16, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.68, green: 0.69, blue: 0.71))
                                    Spacer()
                                }
                                Spacer()
                            }
                        } else {
                            VStack(spacing: 0) {
                                ScrollView(showsIndicators: false) {
                                    ForEach(viewStore.myDepartments) { department in
                                        VStack(spacing: 0) {
                                            HStack {
                                                Text(department.id)
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(.black)
                                                Spacer()
                                                Image(systemName: viewStore.selectedDepartment.id == department.id ? "checkmark.circle.fill" : "circle")
                                                    .foregroundStyle(viewStore.selectedDepartment.id == department.id ? Constants.kuringPrimary : Color.black.opacity(0.1))
                                                    .frame(width: 20, height: 20)
                                            }
                                            .padding(.horizontal, 21.5)
                                            .padding(.top, viewStore.myDepartments.first?.id == department.id ? 22 : 0)
                                            .padding(.bottom, viewStore.myDepartments.last?.id == department.id ? 22 : 0)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                viewStore.send(.departmentGridTapped(department))
                                            }
                                            
                                            // 밑줄
                                            if viewStore.myDepartments.last?.id != department.id {
                                                Rectangle()
                                                    .frame(height: 0.5)
                                                    .foregroundColor(Color.black.opacity(0.1))
                                                    .padding(.top, 16)
                                                    .padding(.bottom, 16)
                                            }
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(Color.black.opacity(0.03))
                            )
                            Spacer()
                        }
                    }
                }
                
                // TODO: 디자인 시스템 분리 - 상단에 블러가 존재하는 버튼
                VStack {
                    // 블러
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 36)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .white, location: 0.00),
                                    Gradient.Stop(color: .white.opacity(0), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.47, y: 1),
                                endPoint: UnitPoint(x: 0.47, y: 0.18)
                            )
                        )
                    
                    // 버튼
                    HStack(alignment: .center, spacing: 10) {
                        Spacer()
                        Text(viewStore.myDepartments.isEmpty ? "학과 추가하기" : "학과 편집하기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
                    .frame(height: 50, alignment: .center)
                    .background(Constants.kuringPrimary)
                    .cornerRadius(100)
                }
            }
            .padding(.horizontal, 20)
            // TODO: TCA에 따라 외부에서 구현
            .navigationTitle("푸시 알림 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("완료") {
                    viewStore.send(.confirmButtonTapped)
                }
            }
        }
    }
    
    // TODO: 디자인 시스템 분리 - 칩
    @ViewBuilder
    private func didSelectChipView(_ title: String) -> some View {
        Group {
            Text(title)
            Rectangle()
                .frame(height: 1.5)
        }
        .foregroundStyle(Color(red: 0.24, green: 0.74, blue: 0.5))
    }
    
    // TODO: 디자인 시스템 분리 - 칩
    @ViewBuilder
    private func deSelectChipView(_ title: String) -> some View {
        Text(title)
            .foregroundColor(.black.opacity(0.3))
    }
}

//#Preview {
//    NavigationStack {
//        SubscriptionView(
//            store: Store(
//                initialState: SubscriptionFeature.State(),
//                reducer: { SubscriptionFeature() }
//            )
//        )
//    }
//}
