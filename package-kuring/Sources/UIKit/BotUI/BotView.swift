//
//  SwiftUIView.swift
//
//
//  Created by 최효원 on 8/5/24.
//

import SwiftUI
import ComposableArchitecture
import ColorSet
import BotFeatures

public struct BotView: View {
    @Bindable var store: StoreOf<BotFeature>
    @FocusState private var isFocused: Bool
    @State private var isShowingPopover = false
    
    public var body: some View {
        ZStack {
            Color.Kuring.bg
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
            VStack(alignment: .center) {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .padding()
                    .frame(width: 20, height: 11)
                    .foregroundStyle(Color.black)
                    Spacer()
                    Text("쿠링봇")
                        .padding()
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                    
                    Button {
                        self.isShowingPopover = true
                    } label: {
                        Image("icon_info_circle", bundle: Bundle.bots)
                    }
                    .popover(
                        isPresented: $isShowingPopover, arrowEdge: .top
                    ) {
                        Text(" ・ 쿠링봇은 2024년 6월 이후의 공지사항 내용을 기준으로 답변할 수 있어요.\n・ 테스트 기간인 관계로 한 달에 2회까지만 질문 가능해요.")
                            .font(.system(size: 15, weight: .medium))
                            .padding()
                    }
                }
                .padding(.horizontal, 18)
                Spacer()
                Image("kuring_app_gray", bundle: Bundle.bots)
                Spacer().frame(height: 20)
                Text("궁금한 건국대학교의\n공지 내용을 질문해보세요")
                    .foregroundStyle(Color.Kuring.caption1)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                Spacer()
                HStack(alignment: .bottom, spacing: 12) {
                    TextField("메세지 입력", text: $store.chatInfo.question.max(), axis: .vertical)
                        .lineLimit(5)
                        .focused($isFocused)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.Kuring.gray200, style: StrokeStyle(lineWidth: 1.0)))
                    
                    Button {
                        isFocused = false
                        
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .foregroundStyle(Color.Kuring.gray400)
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 20)
                Spacer().frame(height: 8)
                Text("쿠링봇은 실수를 할 수 있습니다. 중요한 정보를 확인하세요.")
                    .foregroundStyle(Color.Kuring.caption2)
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.bottom, 16)
        }
    }
    
    public init(store: StoreOf<BotFeature>) {
        self.store = store
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Binding where Value == String {
    func max() -> Self {
        if self.wrappedValue.count > 200 {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

#Preview {
    BotView(
        store: Store(
            initialState: BotFeature.State(),
            reducer: { BotFeature() }
        )
    )
}
