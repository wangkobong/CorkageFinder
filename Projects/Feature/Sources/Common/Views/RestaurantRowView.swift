//
//  RestaurantRowView.swift
//  Feature
//
//  Created by sungyeon on 12/3/24.
//

import SwiftUI
import Models

struct RestaurantRowView: View {
    let restaurant: RestaurantCard
    
    var body: some View {
        HStack(spacing: 12) {
            // 이미지
            AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.system(size: 16, weight: .bold))
                
                Text(restaurant.sigungu)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text("콜키지 \(restaurant.corkageFee)")
                    .font(.system(size: 14))
                
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 12))
                    Text(restaurant.phoneNumber)
                        .font(.system(size: 14))
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
    }
}

struct RestaurantRowView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRowView(restaurant: RestaurantCard.preview)
        .previewLayout(.sizeThatFits)
    }
}
