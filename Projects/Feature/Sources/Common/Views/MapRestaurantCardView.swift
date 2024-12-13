//
//  MapRestaurantCardView.swift
//  Feature
//
//  Created by sungyeon on 12/13/24.
//

import SwiftUI
import Models

struct MapRestaurantCardView: View {
    
    let restaurant: RestaurantCard

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "star")
                    .frame(width: 80, height: 150)
                    .background(Color.yellow)
                VStack(spacing: 5) {
                    HStack {
                        Text(restaurant.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(restaurant.category.title)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                        
                        Spacer()
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text(restaurant.businessHours)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                            Text("15:30 ~ 17:00")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.gray)
                        Text(restaurant.phoneNumber)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "wineglass")
                            .foregroundColor(.gray)
                        Text(restaurant.isCorkageFree ? "무료" : restaurant.corkageFee)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        
                        Spacer()
                    }
                    
                    if restaurant.corkageNote != "" {
                        HStack {
                            Image(systemName: "note")
                                .foregroundColor(.gray)
                            Text(restaurant.corkageNote)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                    
                    HStack {
                        Text("휴무일")
                            .font(.subheadline)
                            .foregroundColor(.red)
                        Text(restaurant.closedDays)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
                
                Spacer()

            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

#Preview {
    MapRestaurantCardView(restaurant: RestaurantCard.preview)
}
