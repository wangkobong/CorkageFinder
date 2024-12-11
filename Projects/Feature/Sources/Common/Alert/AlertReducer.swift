//
//  AlertReducer.swift
//  Feature
//
//  Created by sungyeon on 12/11/24.
//

import ComposableArchitecture

//public struct AlertReducer: Reducer {
//    public struct State: Equatable {
//        public var alert: AlertState
//        
//        public init(alert: AlertState = AlertState()) {
//            self.alert = alert
//        }
//    }
//    
//    public enum Action {
//        case alert(AlertAction)
//    }
//    
//    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        switch action {
//        case .alert(.setPresentationState(let isPresented)):
//            state.alert.isPresented = isPresented
//            return .none
//            
//        case .alert(.primaryButtonTapped):
//            state.alert.isPresented = false
//            return .none
//            
//        case .alert(.secondaryButtonTapped):
//            state.alert.isPresented = false
//            return .none
//        }
//    }
//}
