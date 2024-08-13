//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation
import ComposableArchitecture
import Networks

@Reducer
public struct BotFeature {
    @ObservableState
    public struct State: Equatable {
        public var chatInfo: ChatInfo = .init()
        public var chatHistory: [ChatInfo] = []
        public var focus: Field? = .question
        
        public struct ChatInfo: Equatable, Hashable {
            public var limit: Int = 2
            public var text: String = ""
            public var type: MessageType = .question
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
                type: MessageType = .question,
                chatStatus: ChatStatus = .before
            ) {
                self.limit = limit
                self.text = text
                self.type = type
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
        case addQuestion(String)
        case messageResponse(Result<String, ChatError>)
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
                state.focus = nil
                state.chatInfo.chatStatus = .waiting
                return .run { [question = state.chatInfo.text] send in
                    do {
                        SSEClient.shared.sessionStart(question: question)
                        
                        /// 작업이 취소되거나 완료되기 전까지 send가 호출되지 않도록 보장
                        await withTaskCancellationHandler {
                            let continuation = AsyncStream<String>.Continuation.self
                            
                            ///서버로부터 받은 메시지들을 비동기 스트림으로 처리
                            let stream = AsyncStream<String> { continuation in
                                SSEClient.shared.sendMessage = { message in
                                    continuation.yield(message)
                                }
                            }
                            
                            for await message in stream {
                                await send(.messageResponse(.success(message)))
                            }
                            
                        } onCancel: {
                            SSEClient.shared.task?.cancel()
                        }
                        
                    } catch {
                        await send(.messageResponse(.failure(.serverError(error))))
                    }
                }
                
            case let .messageResponse(.success(message)):
                if let lastMessage = state.chatHistory.last, lastMessage.type == .answer {
                    state.chatHistory[state.chatHistory.count - 1].text += message
                } else {
                    state.chatInfo.text = message
                    state.chatInfo.type = .answer
                    state.chatInfo.chatStatus = .complete
                    state.chatHistory.append(state.chatInfo)
                    state.chatInfo.text = ""
                }
                return .none
                
            case let .messageResponse(.failure(error)):
                state.chatInfo.chatStatus = .failure
                print(error.localizedDescription)
                return .none
                
                
            case let .addQuestion(question):
                let newQuestion = State.ChatInfo(
                    text: question,
                    type: .question,
                    chatStatus: .complete
                )
                state.chatHistory.append(newQuestion)
                return .none
                
                
                
            }
        }
    }
    
    public init() { }
}
