//
//  PendingListRowView.swift
//  Feature
//
//  Created by sungyeon on 1/3/25.
//

import SwiftUI
import Models

struct PendingListRowView: View {
    
    let restaurant: RestaurantCard

    var body: some View {
        HStack(spacing: 12) {
            Text(restaurant.name)
                .font(.body)
            
            Text(restaurant.sido)
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(restaurant.isCorkageFree ? "무료" : "유료")
                .font(.body)
                .foregroundColor(restaurant.isCorkageFree ? .green : .blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

#Preview {
    PendingListRowView(restaurant: RestaurantCard.preview)
        .previewLayout(.sizeThatFits)
}
