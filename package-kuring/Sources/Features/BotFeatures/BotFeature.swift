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
        public var chatInfo: ChatInfo = .init()  // 현재 입력 중인 질문과 그 답변의 상태를 저장하는 구조체
        public var chatHistory: [ChatInfo] = []  // 이전의 질문과 답변을 저장하는 배열
        public var focus: Field? = .question


        // 개별 채팅 정보를 나타내는 구조체
        public struct ChatInfo: Equatable {
            public var question: String = ""      
            public var answer: String = ""
            public var chatStatus: ChatStatus = .before

            // 채팅 상태를 나타내는 열거형
            public enum ChatStatus {
                case before      // 질문 전 상태
                case waiting     // 질문을 보내고 응답을 기다리는 상태
                case complete    // 응답을 성공적으로 받은 상태
                case failure     // 응답을 받지 못한 상태 (오류 발생)
            }

            // 기본 초기화 함수
            public init(
                question: String = "",
                answer: String = "",
                chatStatus: ChatStatus = .before
            ) {
                self.question = question
                self.answer = answer
                self.chatStatus = chatStatus
            }
        }
        
        public enum Field {
            case question
        }

        // 기본 초기화 함수
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
    
   

    // 사용자 동작을 정의하는 열거형
    public enum Action: BindableAction, Equatable {
        case sendMessage  // 질문을 보내는 액션
        case messageResponse(Result<String, ChatError>)  // 서버 응답을 받는 액션
        case updateQuestion(String)  // 사용자가 질문을 입력할 때 상태를 업데이트하는 액션
        case binding(BindingAction<State>)  // 상태 변경을 처리하는 액션

        // 서버 오류를 정의하는 열거형
        public enum ChatError: Error, Equatable {
            case serverError(Error)  // 서버 오류

            public static func == (lhs: ChatError, rhs: ChatError) -> Bool {
                switch (lhs, rhs) {
                case let (.serverError(lhsError), .serverError(rhsError)):
                    return lhsError.localizedDescription == rhsError.localizedDescription
                }
            }
        }
    }

    // 종속성 (Dependencies)
    //@Dependency(\.chatService) var chatService   질문을 서버로 보내고 응답을 받는 서비스

    // 리듀서 본문
    public var body: some ReducerOf<Self> {
        BindingReducer()  // 상태 바인딩을 처리

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .sendMessage:
                guard !state.chatInfo.question.isEmpty else { return .none }  // 질문이 비어있지 않은지 확인
                state.focus = nil
                state.chatInfo.chatStatus = .waiting  // 질문을 보내고 상태를 waiting으로 변경
                return .run { [question = state.chatInfo.question] send in
                    do {
                       // let answer = try await chatService.sendQuestion(question)  // 질문을 보내고 응답을 기다림
                        await send(.messageResponse(.success(question)))  // 응답을 성공적으로 받은 경우
                    } catch {
                        await send(.messageResponse(.failure(.serverError(error))))  // 오류가 발생한 경우
                    }
                }

            case let .messageResponse(.success(answer)):
                state.chatInfo.answer = answer  // 받은 답변을 상태에 저장
                state.chatInfo.chatStatus = .complete  // 상태를 complete로 변경
                state.chatHistory.append(state.chatInfo)  // 현재 채팅 정보를 히스토리에 추가
                state.chatInfo = .init()  // 현재 채팅 정보를 초기화
                return .none

            case let .messageResponse(.failure(error)):
                state.chatInfo.chatStatus = .failure  // 상태를 failure로 변경
                print(error.localizedDescription)  // 오류 메시지 출력
                return .none

            case let .updateQuestion(question):
                state.chatInfo.question = question  // 사용자가 입력한 질문을 상태에 저장
                return .none
            }
        }
    }

    public init() { }
}

    
