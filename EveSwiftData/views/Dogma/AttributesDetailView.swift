//
//  AttributesDetailView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/17/25.
//

import Flow
import SwiftUI

struct AttributesDetailView: View {
  @Binding var categorizedDogmaAttributes: [Int64: [Int64: AttributeValue]]
  var body: some View {
    //ScrollView {
      Grid(alignment: .leading) {
        ForEach(
          categorizedDogmaAttributes.map { $0 },
          id: \.key
        ) { category, attributes in
          DogmaCategoryInfo(categoryId: category)

          ForEach(attributes.map { $0 }, id: \.key) {
            attributeID,
            attributeValue in
            GridRow {
              Text(attributeValue.text)
              Text(String(format: "%.2f", attributeValue.value))
            }
          }

          Divider()
            .gridCellUnsizedAxes(.horizontal)

        }

      }
    //}
  }
}

#Preview {
  AttributesDetailView(
    categorizedDogmaAttributes: Binding(get: { [:] }, set: { _ in })
  )
}
