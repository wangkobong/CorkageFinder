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
            if store.pendingRestaurants.isEmpty {
                Text("신청 대기중인 식당이 없습니다")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            } else {
                ForEach(store.pendingRestaurants, id: \.address) { restaurant in
                    HStack(spacing: 6) {
                        PendingListRowView(restaurant: restaurant)
                            .padding(.leading)
                            .onTapGesture {
                                store.send(.restaurantDetailTap(restaurant))
                            }
                        
                        Button("승인") {
                            store.send(.approve(restaurant))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .foregroundColor(.blue)    // 텍스트 색상
                        .padding(.trailing)
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("신청 대기 목록")
        .onAppear {
            store.send(.fetchPendingRestaurants)
        }
        .loadingOverlay(isLoading: store.isLoading)
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
