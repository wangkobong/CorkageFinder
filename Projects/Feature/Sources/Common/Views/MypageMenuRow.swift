//
//  MypageMenuRow.swift
//  Feature
//
//  Created by sungyeon on 12/27/24.
//

import SwiftUI

struct MypageMenuRow: View {
   let icon: String
   let title: String
   
   var body: some View {
       HStack {
           Image(systemName: icon)
               .frame(width: 24, height: 24)
               .foregroundColor(.primary)
           
           Text(title)
               .foregroundColor(.primary)
           
           Spacer()
           
           Image(systemName: "chevron.right")
               .foregroundColor(.gray)
               .font(.system(size: 14))
       }
       .padding(.horizontal)
       .padding(.vertical, 12)
   }
}

//#Preview {
//    MypageMenuRow()
//}
