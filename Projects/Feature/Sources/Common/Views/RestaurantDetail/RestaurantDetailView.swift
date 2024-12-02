//
//  RestaurantDetailView.swift
//  Feature
//
//  Created by sungyeon on 12/2/24.
//

import SwiftUI
import ComposableArchitecture

struct RestaurantDetailView: View {
    
    @Bindable var store: StoreOf<RestaurantDetailFeature>
    
    public init(store: StoreOf<RestaurantDetailFeature>) {
        self.store = store
    }
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 상단 이미지
                Rectangle()  // 나중에 실제 이미지로 교체
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                
                VStack(alignment: .leading, spacing: 24) {
                    // 기본 정보
                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.restaurant.name)
                            .font(.title2)
                            .bold()
                        
                        Text(store.restaurant.category.title)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // 콜키지 정보
                    VStack(alignment: .leading, spacing: 12) {
                        Text("콜키지 정보")
                            .font(.headline)
                        
                        HStack {
                            Text("비용")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(store.restaurant.corkageFee)
                                .foregroundColor(store.restaurant.isCorkageFree ? .green : .primary)
                        }
                        
                        if !store.restaurant.corkageNote.isEmpty {
                            Text("특이사항")
                                .foregroundColor(.gray)
                            Text(store.restaurant.corkageNote)
                        }
                    }
                    
                    Divider()
                    
                    // 식당 정보
                    VStack(alignment: .leading, spacing: 12) {
                        Text("매장 정보")
                            .font(.headline)
                        
                        InfoRow(icon: "clock", title: "영업시간", content: store.restaurant.businessHours)
                        InfoRow(icon: "calendar", title: "휴무일", content: store.restaurant.closedDays)
                        InfoRow(icon: "phone", title: "전화번호", content: store.restaurant.phoneNumber)
                        InfoRow(icon: "map", title: "주소", content: "\(store.restaurant.sido) \(store.restaurant.sigungu)\n\(store.restaurant.address)")
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}



extension RestaurantCard {
   static let preview = RestaurantCard(
       imageURL: "restaurant1.jpg",
       name: "우리집 레스토랑",
       category: .korean,
       isCorkageFree: false,
       corkageFee: "30,000원",
       sido: "서울특별시",
       sigungu: "강남구",
       phoneNumber: "02-555-1234",
       address: "서울특별시 강남구 신사동 123-45",
       businessHours: "11:30 - 22:00",
       closedDays: "매주 월요일",
       corkageNote: "와인 1병당 30,000원, 최대 2병까지 가능"
   )
}

#Preview {
   NavigationView {
       RestaurantDetailView(
           store: Store(
            initialState: RestaurantDetailFeature.State(restaurant: .preview)
           ) {
               RestaurantDetailFeature()
           }
       )
   }
}
