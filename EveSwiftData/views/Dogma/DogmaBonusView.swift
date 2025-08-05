//
//  DogmaBonusView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/30/25.
//

import SwiftUI

struct DogmaBonusView: View {
    var dogmaAttributes: [Int64: AttributeValue] = [:]
    
    var body: some View {
        ScrollView {
            Grid(alignment: .leading) {
                ForEach(Array(dogmaAttributes.values), id: \.attributeId) { value in
                    GridRow {
                        //AttributeInfo(attributeId: value.attributeId)
                        Text("\(value.text)")
                        Text(String(format: "%.2f", value.value))
                    }.border(.red)
                    
                }
            }
            
        }
        
    }
}

#Preview {
    DogmaBonusView()
}
