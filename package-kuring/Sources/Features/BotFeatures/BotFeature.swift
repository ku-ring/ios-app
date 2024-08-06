//
//  File.swift
//
//
//  Created by 최효원 on 8/5/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct BotFeature {
    @ObservableState
    public struct State: Equatable {
        public var chatInfo: ChatInfo = .init()
        public var chatHistory: [ChatInfo] = []
        public var focus: Field? = .question

        public struct ChatInfo: Equatable {
            public var limit: Int = 2
            public var text: String = ""
            public var messageType: MessageType = .question
            public var chatStatus: ChatStatus = .before
            
            public enum MessageType: String, Equatable {
                case question
                case answer
            }
            
            public enum ChatStatus {
                /// 질문 보내기 전
                case before
                /// 질문 보낸 후
                case waiting
                /// 답변 완료
                case complete
                /// 답변 실패
                case failure
            }
            
            public init(
                limit: Int = 2,
                text: String = "",
                messageType: MessageType = .question,
                chatStatus: ChatStatus = .before
            ) {
                self.limit = limit
                self.text = text
                self.messageType = messageType
                self.chatStatus = chatStatus
            }
        }
        
        public enum Field {
            case question
        }
        
        public init(
            chatInfo: ChatInfo = .init(),
            chatHistory: [ChatInfo] = [],
            focus: Field? = .question
        ) {
            self.chatInfo = chatInfo
            self.chatHistory = chatHistory
            self.focus = focus
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case sendMessage
        case messageResponse(Result<String, ChatError>)
        case updateQuestion(String)
        case binding(BindingAction<State>)
        
        public enum ChatError: Error, Equatable {
            case serverError(Error)
            
            public static func == (lhs: ChatError, rhs: ChatError) -> Bool {
                switch (lhs, rhs) {
                case let (.serverError(lhsError), .serverError(rhsError)):
                    return lhsError.localizedDescription == rhsError.localizedDescription
                }
            }
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .sendMessage:
                guard !state.chatInfo.text.isEmpty else { return .none }
                state.focus = nil
                state.chatInfo.chatStatus = .waiting
                return .run { [question = state.chatInfo.text] send in
                    do {
                        // let answer = try await chatService.sendQuestion(question)
                        /// 임시 응답
                        await send(.messageResponse(.success(question)))
                    } catch {
                        await send(.messageResponse(.failure(.serverError(error))))
                    }
                }
                
            case let .messageResponse(.success(answer)):
                state.chatInfo.text = answer
                state.chatInfo.chatStatus = .complete
                state.chatHistory.append(state.chatInfo)
                state.chatInfo = .init()
                return .none
                
            case let .messageResponse(.failure(error)):
                state.chatInfo.chatStatus = .failure
                print(error.localizedDescription)
                return .none
                
            case let .updateQuestion(question):
                state.chatInfo.text = question
                return .none
            }
        }
    }
    
    public init() { }
}
