//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation
import ComposableArchitecture
import Networks
import SwiftData
import Models
import Dependencies
import Caches

@Reducer
public struct BotFeature {
    @ObservableState
    public struct State: Equatable {
        public var chatInfo: ChatInfo = .init()
        public var chatHistory: [ChatInfo] = []
        public var focus: Field? = .question
        
        public init(
            chatInfo: ChatInfo = .init(),
            chatHistory: [ChatInfo] = [],
            focus: Field? = .question
        ){
            self.chatInfo = chatInfo
            self.chatHistory = chatHistory
            self.focus = focus
        }
        
        var fetchDescriptor: FetchDescriptor<ChatInfo> {
            return .init()
        }
        
        mutating func refetchChat() {
            @Dependency(\.bots) var context
            do {
                self.chatHistory = try context.fetch(self.fetchDescriptor)
            } catch {}
        }
    }
    
    public enum Field {
        case question
    }
    
    public enum Action: BindableAction, Equatable {
        case sendMessage
        case addQuestion(String)
        case messageResponse(Result<String, ChatError>)
        case binding(BindingAction<State>)
        case queryChanged([ChatInfo])
        case onAppear
        
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
    
    @Dependency(\.bots) public var context
    
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
                    let newResponse = ChatInfo(
                        index: state.chatHistory.count + 1,
                        text: message,
                        type: .answer,
                        chatStatus: .complete
                    )
                    state.chatHistory.append(newResponse)
                    do { try context.add(newResponse) } catch {}
                }
                return .none
                
            case let .messageResponse(.failure(error)):
                state.chatInfo.chatStatus = .failure
                print(error.localizedDescription)
                return .none
                
            case let .addQuestion(question):
                let newQuestion = ChatInfo(
                    index: state.chatHistory.count + 1,
                    text: question,
                    type: .question,
                    chatStatus: .complete
                )
                do { try context.add(newQuestion) } catch {}
                state.chatHistory.append(newQuestion)
                return .none
                
            case .queryChanged(let newMessage):
                state.chatHistory = newMessage
                return .none
                
            case .onAppear:
                state.refetchChat()
                return .none
            }
        }
    }
    
    public init() {}
}

