import Models
import SwiftUI
import DepartmentFeatures
import ComposableArchitecture

public struct DepartmentSelector: View {
    @Bindable var store: StoreOf<DepartmentSelectorFeature>
    
    public var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                Text("대표 학과 선택")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.black)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 12)
            .frame(width: 375, alignment: .leading)
            
            ScrollView {
                ForEach(store.addedDepartment) { department in
                    HStack {
                        Text(department.korName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Image(
                            systemName: department == store.currentDepartment
                            ? "checkmark.circle.fill"
                            : "circle"
                        )
                        .foregroundStyle(
                            department == store.currentDepartment
                            ? Color.accentColor
                            : Color.black.opacity(0.1)
                        )
                        .frame(width: 20, height: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.white)
                    .onTapGesture {
                        store.send(.selectDepartment(id: department.id))
                    }
                }
            }
            
            Button {
                store.send(.editDepartmentsButtonTapped)
            } label: {
                topBlurButton(
                    "내 학과 편집하기",
                    fontColor: Color.accentColor,
                    backgroundColor: Color.accentColor.opacity(0.15)
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    // TODO: 디자인 시스템 분리 - 상단에 블러가 존재하는 버튼
    @ViewBuilder
    private func topBlurButton(_ title: String, fontColor: Color, backgroundColor: Color) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fontColor)
            Spacer()
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .frame(height: 50, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(100)
        .background {
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom)
                .offset(x: 0, y: -32)
        }
    }
    
    public init(store: StoreOf<DepartmentSelectorFeature>) {
        self.store = store
    }
}

#Preview {
    NavigationStack {
        DepartmentSelector(
            store: Store(
                initialState: DepartmentSelectorFeature.State(
                    addedDepartment: [
                        NoticeProvider.departments[0],
                        NoticeProvider.departments[1],
                        NoticeProvider.departments[2],
                    ]
                ),
                reducer: { DepartmentSelectorFeature() }
            )
        )
        .navigationTitle("Department Selector")
    }
}
