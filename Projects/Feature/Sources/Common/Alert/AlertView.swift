////
////  AlertView.swift
////  Feature
////
////  Created by sungyeon on 12/11/24.
////
//
//import SwiftUI
//import ComposableArchitecture
//
//public struct AlertView: View {
//    let store: StoreOf<AlertReducer>
//    
//    public init(store: StoreOf<AlertReducer>) {
//        self.store = store
//    }
//    
//    public var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            EmptyView()
//                .alert(
//                    viewStore.alert.title,
//                    isPresented: viewStore.binding(
//                        get: \.alert.isPresented,
//                        send: { .alert(.setPresentationState(isPresented: $0)) }
//                    )
//                ) {
//                    Button(viewStore.alert.primaryButtonTitle) {
//                        viewStore.send(.alert(.primaryButtonTapped))
//                    }
//                    
//                    if let secondaryButtonTitle = viewStore.alert.secondaryButtonTitle {
//                        Button(secondaryButtonTitle) {
//                            viewStore.send(.alert(.secondaryButtonTapped))
//                        }
//                    }
//                } message: {
//                    if let message = viewStore.alert.message {
//                        Text(message)
//                    }
//                }
//        }
//    }
//}
//
//#Preview {
//    AlertView(
//        store: Store(
//            initialState: AlertReducer.State()
//        ) {
//            AlertReducer()
//        }
//    )
//}
//
