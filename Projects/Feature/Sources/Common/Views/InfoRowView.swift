//
//  InfoRowView.swift
//  Feature
//
//  Created by sungyeon on 12/2/24.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.gray)
                Text(content)
            }
        }
    }
}

#Preview {
    InfoRow(icon: "", title: "테스트", content: "콘텐츠")
}
