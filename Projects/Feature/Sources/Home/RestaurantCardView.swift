//
//  RestaurantCardView.swift
//  Feature
//
//  Created by sungyeon on 11/29/24.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: RestaurantCard
    
    var body: some View {
        VStack(alignment: .leading) {
            // 이미지 플레이스홀더
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 150, height: 150)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.system(size: 16, weight: .medium))
                
                Text(restaurant.category.title)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(restaurant.corkageFee)
                    .font(.system(size: 14))
                    .foregroundColor(restaurant.isCorkageFree ? .green : .black)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
        .frame(width: 150)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    RestaurantCardView(restaurant: RestaurantCard(imageURL: "",
                                                  name: "이자카야 료",
                                                  category: .japanese,
                                                  isCorkageFree: true,
                                                  corkageFee: "무료",
                                                  sido: "경기도",
                                                  sigungu: "분당구",
                                                  phoneNumber: "031-712-5678",
                                                  address: "경기도 성남시 분당구 수내동 012-34",
                                                  businessHours: "17:00 - 23:30",
                                                  closedDays: "매주 월요일",
                                                  corkageNote: "콜키지 무료, 일본 사케 반입 가능"))
}
