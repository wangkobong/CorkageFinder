//
//  RestaurantImageScrollView.swift
//  Feature
//
//  Created by sungyeon on 12/19/24.
//

import SwiftUI
import Kingfisher
import Models

struct RestaurantImageCarouselWithPaging: View {
    let imageURLs: [String]
    @State private var currentIndex = 0
    
    var body: some View {
        TabView(selection: $currentIndex) {
            if imageURLs.isEmpty {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
            } else {
                ForEach(Array(imageURLs.enumerated()), id: \.element) { index, urlString in
                    KFImage(URL(string: urlString))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                        .tag(index)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 250)
    }
}
#Preview {
    RestaurantImageCarouselWithPaging(imageURLs: RestaurantCard.preview.imageURLs)
}
