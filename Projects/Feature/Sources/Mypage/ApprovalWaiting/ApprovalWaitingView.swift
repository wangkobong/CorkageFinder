//
//  ApprovalWaitingView.swift
//  Feature
//
//  Created by sungyeon on 1/2/25.
//

import SwiftUI
import ComposableArchitecture

struct ApprovalWaitingView: View {
    
    let store: StoreOf<ApprovalWaitingFeature>
    
    public init(store: StoreOf<ApprovalWaitingFeature>) {
        self.store = store
    }

    var body: some View {
        Text("승인대기중")
    }
}

#Preview {
    ApprovalWaitingView(
        store: Store(
            initialState: ApprovalWaitingFeature.State()
        ) {
            ApprovalWaitingFeature()
        }
    )
}
