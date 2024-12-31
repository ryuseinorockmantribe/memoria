//
//  CardView.swift
//  Memoria
//
//  Created by App Designer2 on 25.09.24.
//

import SwiftUI

struct CardView: View {
    var symbol: String
    var isFlipped: Bool
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(isFlipped ? Color.white : Color.purple)
                .frame(width: 50, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
            
            if isFlipped {
                Text(symbol)
                    .font(.largeTitle)
                    .transition(.scale)
            }
        }
    }
}

