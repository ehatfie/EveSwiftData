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
  var defaultCategorizedDogmaAttributes: [Int64: [Int64: AttributeValue]]
  var body: some View {
    //ScrollView {
    Grid(alignment: .leading) {
      GridRow {
        Text("Attribute")
        Text("Original")
        Text("Modified")
      }
      .font(.headline)
      .padding(.bottom, 5)

      ForEach(
        categorizedDogmaAttributes.map { $0 },
        id: \.key
      ) { category, attributes in
        DogmaCategoryInfo(categoryId: category)
        ForEach(attributes.map { $0 }, id: \.key) {
          attributeID,
          attributeValue in

          GridRow {
            Text(attributeValue.text + " \(attributeID)")
            viewForAttribute(attributeID, attributeValue)
            Text(String(format: "%.2f", attributeValue.value))
          }
        }

        Divider()
          .gridCellUnsizedAxes(.horizontal)

      }

    }

    //}
  }

  @ViewBuilder
  func viewForAttribute(
    _ attributeID: Int64,
    _ attributeValue: AttributeValue
  ) -> some View {
    switch attributeID {
    case 182, 183, 184:
      attributeDetail(attributeID, attributeValue)
    case 605:
      attributeDetail(attributeID, attributeValue)
    default:
      attributeData(attributeID, attributeValue)
    }

  }

  @ViewBuilder
  func attributeDetail(
    _ attributeID: Int64,
    _ attributeValue: AttributeValue
  ) -> some View {
    let attributeVal = getDefaultValue(for: attributeValue)
    TypeInfo(typeId: Int64(attributeVal))
  }

  func attributeData(
    _ attributeID: Int64,
    _ attributeValue: AttributeValue
  ) -> some View {
    Text(
      String(
        format: "%.2f",
        getDefaultValue(for: attributeValue)
      )
    )
  }

  func getDefaultValue(for attributeValue: AttributeValue) -> Double {
    //return defaultCategorizedDogmaAttributes
    if let categoryId = attributeValue.categoryId,
      let value = defaultCategorizedDogmaAttributes[categoryId]
    {
      return value[attributeValue.attributeId]?.value ?? 0.0
    }
    return 0.0
  }
  
  func getModifiedValue(for attributeValue: AttributeValue) -> Double {
    if let categoryId = attributeValue.categoryId,
      let value = categorizedDogmaAttributes[categoryId]
    {
      return value[attributeValue.attributeId]?.value ?? 0.0
    }

    return 0.0
  }
}

#Preview {
  AttributesDetailView(
    categorizedDogmaAttributes: Binding(get: { [:] }, set: { _ in }),
    defaultCategorizedDogmaAttributes: [:]
  )
}
