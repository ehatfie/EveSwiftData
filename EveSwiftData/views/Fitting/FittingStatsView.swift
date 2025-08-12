//
//  FittingStatsView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/10/25.
//

import SwiftUI

struct FittingStatsView: View {
  var dogmaAttributes: [Int64: [Int64: AttributeValue]]
  
  var body: some View {
    VStack {
      DogmaResistanceView(shieldDogmaAttributes: dogmaAttributes[2, default: [:]])
      DogmaResistanceView(armorDogmaAttributes: dogmaAttributes[3, default: [:]])
      DogmaResistanceView(hullDogmaAttributes: dogmaAttributes[4, default: [:]])
    }
  }
}

#Preview {
  FittingStatsView(dogmaAttributes: [:])
}
