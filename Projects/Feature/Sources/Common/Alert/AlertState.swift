////
////  AlertState.swift
////  Feature
////
////  Created by sungyeon on 12/11/24.
////
//
//import ComposableArchitecture
//import SwiftUI
//
//public struct AlertState: Equatable {
//    public var isPresented: Bool
//    public var title: String
//    public var message: String?
//    public var primaryButtonTitle: String
//    public var secondaryButtonTitle: String?
//    
//    public init(
//        isPresented: Bool = false,
//        title: String = "",
//        message: String? = nil,
//        primaryButtonTitle: String = "확인",
//        secondaryButtonTitle: String? = nil
//    ) {
//        self.isPresented = isPresented
//        self.title = title
//        self.message = message
//        self.primaryButtonTitle = primaryButtonTitle
//        self.secondaryButtonTitle = secondaryButtonTitle
//    }
//}
//
//public enum AlertAction: Equatable {
//    case setPresentationState(isPresented: Bool)
//    case primaryButtonTapped
//    case secondaryButtonTapped
//}
