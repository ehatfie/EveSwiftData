//
//  EffectInfo.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/14/25.
//
import SwiftData
import SwiftUI

struct EffectInfo: View {
  @Query private var dogmaEffectModels: [DogmaEffectModel]

  var dogmaEffectModel: DogmaEffectModel {
    let model = dogmaEffectModels[0]
    return model
  }

  init(effectId: Int64) {
    self._dogmaEffectModels = Query(
      filter: DogmaEffectModel.predicate(effectId: effectId)
    )
  }

  var body: some View {
    Grid(alignment: .leading) {
      Text(dogmaEffectModel.effectName + " \(dogmaEffectModel.effectID)")
        .font(.title2)
        .padding(.bottom, 5)
      VStack(alignment: .leading) {
        if let descriptionID = dogmaEffectModel.descriptionID {
          VStack(alignment: .leading) {
            Text("DescriptionID")
              .font(.subheadline)
            Text(descriptionID)
          }
        }
        
        if let displayNameID = dogmaEffectModel.displayNameID {
          VStack(alignment: .leading) {
            Text("DisplayNameID")
              .font(.subheadline)
            Text(displayNameID)
          }
        }
      }

      if let dischargeAttributeID = dogmaEffectModel.dischargeAttributeID {
        VStack(alignment: .leading) {
          Text("DischargeAttributeID \(dischargeAttributeID)")
            .font(.headline)
          AttributeInfo(attributeId: dischargeAttributeID)
        }
      }
      ForEach(dogmaEffectModel.modifierInfo, id: \.modifiedAttributeID) {
        dogmaEffect in
        GridRow {
//          VStack(alignment: .leading, spacing: 10) {
          HStack(alignment: .top, spacing: 10) {
            GroupBox {
              VStack(alignment: .leading, spacing: 10) {
                Text("Modifying \(dogmaEffect.modifiyingAttributeID)")
                AttributeInfo(
                  attributeId: dogmaEffect.modifiyingAttributeID
                )
              }
            }.border(.red)
            GroupBox {
              VStack(alignment: .leading, spacing: 10) {
                Text("Modified \(dogmaEffect.modifiedAttributeID)")
                AttributeInfo(
                  attributeId: dogmaEffect.modifiedAttributeID
                )
              }
            }.border(.blue)
          }
        }
        VStack(alignment: .leading) {
          HStack {
            Text("SkillID \(dogmaEffect.skillTypeID)")
            TypeInfo(
              typeId: dogmaEffect.skillTypeID
            )
          }
          HStack {
            Text("Function")
            Text("\(dogmaEffect.function)")
          }
          HStack {
            Text("Domain")
            Text("\(dogmaEffect.domain)")
          }
          HStack {
            Text("Operation")
            Text("\(dogmaEffect.operation)")
          }

        }
      }

    }

  }
}
