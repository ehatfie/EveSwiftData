//
//  FittingResistanceView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/25/25.
//

import SwiftUI

struct FittingResistance {
  var em: Double
  var thermal: Double
  var kinetic: Double
  var explosive: Double

  init(em: Double, thermal: Double, kinetic: Double, explosive: Double) {
    self.em = em
    self.thermal = thermal
    self.kinetic = kinetic
    self.explosive = explosive
  }
}

struct DogmaResistanceView: View {
  let dogmaDescription: String
  let value: Double
  let dogmaAttributes: [AttributeValue]
  
  let barWidth: CGFloat = 100
  let barHeight: CGFloat = 10
  
  init?(shieldDogmaAttributes: [Int64: AttributeValue]) {
    guard let bufferAttribute = shieldDogmaAttributes[263],
          let em = shieldDogmaAttributes[271],
          let thermal = shieldDogmaAttributes[274],
          let kinetic = shieldDogmaAttributes[273],
          let explosive = shieldDogmaAttributes[272]
    else {
      return nil
    }
      value = bufferAttribute.value
    dogmaDescription = "Shield"
    self.dogmaAttributes = [em,thermal,kinetic,explosive]
  }
  
  init?(armorDogmaAttributes: [Int64: AttributeValue]) {
    guard let bufferAttribute = armorDogmaAttributes[265],
          let em = armorDogmaAttributes[267],
          let thermal = armorDogmaAttributes[270],
          let kinetic = armorDogmaAttributes[269],
          let explosive = armorDogmaAttributes[268]
    else {
      print("++ missing dogma armor attribute")
      return nil
    }
    dogmaDescription = "Armor"
      value = bufferAttribute.value
    self.dogmaAttributes = [em,thermal,kinetic,explosive]
  }
  
  init?(hullDogmaAttributes: [Int64: AttributeValue]) {
    guard let bufferAttribute = hullDogmaAttributes[9],
          let em = hullDogmaAttributes[113],
          let thermal = hullDogmaAttributes[110],
          let kinetic = hullDogmaAttributes[109],
          let explosive = hullDogmaAttributes[111]
    else {
      print("++ missing dogma hull attribute")
      return nil
    }
    dogmaDescription = "Hull"
      value = bufferAttribute.value
    self.dogmaAttributes = [em,thermal,kinetic,explosive]
  }
  
  init(dogmaAttributes: [AttributeValue]) {
    self.dogmaAttributes = dogmaAttributes
    dogmaDescription = "Default"
    value = 10000
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack {
        Text(dogmaDescription)
        Text(String(format: "%.0f", Double(value)))
      }
      Grid(alignment: .leading, verticalSpacing: 0) {
        ForEach(dogmaAttributes) { attribute in
          GridRow {
            ZStack(alignment: .leading) {
              Rectangle()
                .fill(getAttributeColor(attributeId: attribute.attributeId))
                .frame(width: getLength(value: attribute.value), height: barHeight)
              Rectangle()
                .fill(getAttributeColor(attributeId: attribute.attributeId).opacity(0.55))
                .frame(width: barWidth, height: barHeight)
            }
              Text(String(format: "%.2f", Double((1 - attribute.value) * 100)))
                .foregroundStyle(Color.white)
                .font(.footnote)
          }
        }
      }
    }
  }
  
  func getAttributeColor(attributeId: Int64) -> Color {
    switch attributeId {
    case 271, 267, 113: // EM
      return .blue
    case 274, 270, 110: // Thermal
      return .red
    case 273, 279, 109: // Kinetic
      return .gray
    case 272, 268, 111: // Explosive
      return .yellow
    default:
      return .gray
    }
  }
  
  func getLength(value: Double) -> CGFloat {
    return barWidth * CGFloat(1 - value)
  }
}

#Preview {
  DogmaResistanceView(
    dogmaAttributes: [
      .init(value: 0.11, attributeId: 271, categoryId: nil, text: "EM"),
      .init(value: 0.44, attributeId: 274, categoryId: nil, text: "Thermal"),
      .init(value: 0.33, attributeId: 273, categoryId: nil, text: "Kinetic"),
      .init(value: 0.22, attributeId: 272, categoryId: nil, text: "Explosive"),
    ]
  )
}
