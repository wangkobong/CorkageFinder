//
//  TestFeature.swift
//  Feature
//
//  Created by sungyeon on 11/27/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct CounterFeature: Equatable {
    @ObservableState
    public struct State: Equatable {
        public var count = 0
        public var fact: String?
        public var isLoading = false
        public var isTimerRunning = false

        
        public init() {}
    }
    
    public enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factResponse(String)
        case factButtonTapped
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID { case timer }

    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .factButtonTapped:
                    state.fact = nil
                    state.isLoading = true
                return .run { [count = state.count] send in
                    do {
                        let (data, _) = try await URLSession.shared
                            .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                        let fact = String(decoding: data, as: UTF8.self)
                        await send(.factResponse(fact))
                    } catch {
                        // 에러 발생시 에러 메시지를 전송
                        await send(.factResponse("Failed to load fact: \(error.localizedDescription)"))
                    }
                }

            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                  return .run { send in
                    while true {
                      try await Task.sleep(for: .seconds(1))
                      await send(.timerTick)
                    }
                  }
                  .cancellable(id: CancelID.timer)
                } else {
                  return .cancel(id: CancelID.timer)
                }
                
            case .timerTick:
                    state.count += 1
                    state.fact = nil
                    return .none
            }
        }
    }
}
