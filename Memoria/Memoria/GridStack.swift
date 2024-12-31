//
//  GridStack.swift
//  Memoria
//
//  Created by App Designer2 on 25.09.24.
//

import SwiftUI

struct GridStack: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> AnyView
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<rows, id: \.self) { row in
            
                HStack(spacing: 10) {
                    ForEach(0..<self.columns, id: \.self) { columns in
                        content(row, columns)
                    }
                }
            }
        }
    }
}
