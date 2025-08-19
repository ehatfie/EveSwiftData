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
      if let descriptionID = dogmaEffectModel.descriptionID {
        VStack(alignment: .leading) {
          Text("DescriptionID")
          Text(descriptionID)
        }
      }
      if let displayNameID = dogmaEffectModel.displayNameID {
        VStack(alignment: .leading) {
          Text("DisplayNameID")
          Text(displayNameID)
        }
      }
      if let dischargeAttributeID = dogmaEffectModel.dischargeAttributeID {
        VStack(alignment: .leading) {
          Text("DischargeAttributeID")

          AttributeInfo(attributeId: dischargeAttributeID)
        }
      }
      ForEach(dogmaEffectModel.modifierInfo, id: \.modifiedAttributeID) {
        dogmaEffect in
        GridRow {
          VStack(alignment: .leading, spacing: 10) {
            GroupBox {
              VStack(alignment: .leading) {
                Text("Modifying \(dogmaEffect.modifiyingAttributeID)")
                AttributeInfo(
                  attributeId: dogmaEffect.modifiyingAttributeID
                )
              }.padding()
            }
            GroupBox {
              VStack(alignment: .leading) {
                Text("Modified \(dogmaEffect.modifiedAttributeID)")
                AttributeInfo(
                  attributeId: dogmaEffect.modifiedAttributeID
                )
              }.padding()
            }
          }
        }.padding()
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
