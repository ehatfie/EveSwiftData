//
//  ShipFittingDataView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/2/25.
//

import SwiftUI

struct ShipFittingDataView: View {
  var fittingAttributes: [Int64: AttributeValue] = [:]
  
  var displayData: [IdentifiedString] = []

  init(fittingAttributes: [Int64: AttributeValue]) {
    self.fittingAttributes = fittingAttributes
    
    let fittingAttributes: [Int64: AttributeValue] = self.fittingAttributes
    var returnData: [IdentifiedString] = []
    let attributes: [DogmaAttributeCategory.Fitting] = [
      .highSlot,
      .midslot,
      .lowSlot,
      .subsystemSlot,
      .rigSlot,
    ]
    
    for value in attributes {
      guard let existing = fittingAttributes[value.rawValue] else { continue }
      var placeholders: [IdentifiedString] = []
      
      for i in 0..<Int(existing.value) {
        placeholders.append(
          IdentifiedString(
            key: "\(existing.attributeId)_\(i)",
            typeId: Int64(i),
            value: "-"
          )
        )
      }

      let displayValue: IdentifiedString = IdentifiedString(
        typeId: value.rawValue,
        value: value.text + "\(existing.value)",
        content: placeholders
      )
      
      returnData.append(displayValue)
    }
    self.displayData = returnData
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("ShipFittingDataView")
      ForEach(displayData) { data in
        VStack(alignment: .leading) {
          Text(data.value)
          if let content = data.content {
            VStack(alignment: .leading) {
              ForEach(content, id: \.typeId) { value in
                Text(value.value)
              }
            }
            
          }
        }
      }
    }
  }
}

#Preview {
  ShipFittingDataView(fittingAttributes: [:])
}
