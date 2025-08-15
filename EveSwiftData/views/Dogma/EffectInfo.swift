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
    GroupBox {
      VStack(alignment: .leading) {
        Text(dogmaEffectModel.effectName + " \(dogmaEffectModel.effectID)")
        if let descriptionID = dogmaEffectModel.descriptionID {
          HStack {
            Text("DescriptionID")
            Text(descriptionID)
              .fixedSize(horizontal: false, vertical: true)
          }
          
        }
        if let displayNameID = dogmaEffectModel.displayNameID {
          VStack {
            Text("DisplayNameID")
            Text(displayNameID)
              .fixedSize(horizontal: false, vertical: true)
          }
        }
        
        GroupBox {
          Grid {
            Text(dogmaEffectModel.effectName)
            if let descriptionID = dogmaEffectModel.descriptionID {
              HStack {
                Text("DescriptionID")
                Text(descriptionID)
              }
            }
            if let displayNameID = dogmaEffectModel.displayNameID {
              HStack {
                Text("DisplayNameID")
                Text(displayNameID)
              }
            }
            if let dischargeAttributeID = dogmaEffectModel.dischargeAttributeID {
              HStack {
                Text("DischargeAttributeID")
                
                AttributeInfo(attributeId: dischargeAttributeID)
              }
            }
          }
        }
        ForEach(dogmaEffectModel.modifierInfo, id: \.modifiedAttributeID) { dogmaEffect in
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
              
              VStack(alignment: .leading) {
                Text("SkillID \(dogmaEffect.skillTypeID)")
                TypeInfo(
                  typeId: dogmaEffect.skillTypeID
                )
              }

              VStack(alignment: .leading) {
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
              
            }.padding()
          }
        }
        
      }
    }
  }
}
