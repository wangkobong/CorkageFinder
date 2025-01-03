//
//  ApprovalWaitingView.swift
//  Feature
//
//  Created by sungyeon on 1/2/25.
//

import SwiftUI
import Models
import ComposableArchitecture

struct ApprovalWaitingView: View {
    
    @Bindable var store: StoreOf<ApprovalWaitingFeature>
    
    public init(store: StoreOf<ApprovalWaitingFeature>) {
        self.store = store
    }

    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(store.pendingRestaurants, id: \.address) { restaurant in
                PendingListRowView(restaurant: restaurant)
                    .padding(.horizontal)
                    .onTapGesture {
                        store.send(.restaurantDetailTap(restaurant))
                    }
            }
            Spacer()
        }
        .navigationTitle("신청 대기 목록")
        .onAppear {
            store.send(.fetchPendingRestaurants)
        }
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
