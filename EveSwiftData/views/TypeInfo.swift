//
//  TypeInfo.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/23/25.
//

import SwiftUI
import SwiftData

struct TypeInfo: View {
  @Query private var typeModels: [TypeModel]
  
  var showDetails: Bool = false
  
  var typeModel: TypeModel {
    typeModels.first ?? TypeModel(
      typeId: -1,
      data: TypeData(
        groupID: 0,
        name: ThingName(
          name: "NO NAME"
        ),
        published: true,
        traits: TypeTraits(
          //miscBonuses: [],
          roleBonuses: [
            RoleBonuses(
              bonus: 0.0,
              bonusText: ThingName(name: "TestRoleBOnus"),
              importance: 0,
              unitID: 0
            )
          ],
          types: [:]
        )
      )
    )
  }
  
  //    var dogmaInfo: TypeDogmaInfoModel {
  //      dogmaAttributes[0]
  //    }
  
  init(typeId: Int64) {
    self._typeModels = Query(
      filter: TypeModel.predicate(typeId: typeId)
    )
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(typeModel.name)
        .font(.title3)
      
      if showDetails {
        details()
      }
    }
  }
  
  func details() -> some View {
    VStack {
      if let descriptionString = typeModel.descriptionString {
        Text(typeModel.descriptionString ?? "")
          .font(.callout)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}

struct AttributeInfo: View {
  @Query private var attributeModels: [DogmaAttributeModel]
  
  var attributeModel: DogmaAttributeModel? {
    guard let attributeModel = attributeModels.first else {
      return nil
    }
    return attributeModel
  }
  
  //    var dogmaInfo: TypeDogmaInfoModel {
  //      dogmaAttributes[0]
  //    }
  let attributeId: Int64
  init?(attributeId: Int64) {
    self.attributeId = attributeId
    self._attributeModels = Query(
      filter: DogmaAttributeModel.predicate(attributeId: attributeId)
    )
  }
  
  var body: some View {
    if let attributeModel = attributeModel {
      VStack(alignment: .leading) {
        if let displayNameID = attributeModel.displayNameID {
          HStack(alignment: .top) {
            Text("DisplayNameID")
            Text(displayNameID)
          }
        }
        if let attributeDescription = attributeModel.attributeDescription {
          HStack(alignment: .top) {
            Text("AttributeDescription")
            Text(attributeDescription)
          }
  //        Text(attributeDescription)
  //          .fixedSize(horizontal: false, vertical: true)
        } else {
          HStack(alignment: .top) {
            Text("Name")
            Text(attributeModel.name)
              .fixedSize(horizontal: false, vertical: true)
          }
          
        }
        if let categoryID = attributeModel.categoryID {
          Text("CategoryID \(categoryID)")
          DogmaCategoryInfo(categoryId: categoryID)
        }
        
        if let tooltipTitleID = attributeModel.tooltipTitleID, !tooltipTitleID.isEmpty {
          HStack(alignment: .top) {
            Text("ToolTipTitleID")
            Text("\(tooltipTitleID)")
          }
        }
        
        if let tooltipDescriptionID = attributeModel.tooltipDescriptionID, !tooltipDescriptionID.isEmpty {
          HStack(alignment: .top) {
            Text("ToolTipDescriptionID")
            Text("\(tooltipDescriptionID)")
          }
         
        }
        
  //      //Text("Defaultvalue \(attributeModel.defaultValue)")
  //
  //      if let tooltipTitleID = attributeModel.tooltipTitleID {
  //        //Text("ToolTipTitleID \(tooltipTitleID)")
  //      }
  //
  //      if let tooltipDescriptionID = attributeModel.tooltipDescriptionID {
  //        //Text("ToolTipDescriptionID \(tooltipDescriptionID)")
  //      }
        if let unitID = attributeModel.unitID {
          Text("UnitID \(unitID)")
          
        }
        if let displayNameID = attributeModel.displayNameID {
          Text(displayNameID)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    } else {
      EmptyView()
    }
  }
}

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
        HStack {
          Text("DisplayNameID")
          Text(displayNameID)
            .fixedSize(horizontal: false, vertical: true)
        }
        
      }
      TypeInfo(typeId: dogmaEffectModel.effectID)
          .border(.orange)

      Grid {
        Text(dogmaEffectModel.effectName)
        
        if let descriptionID = dogmaEffectModel.descriptionID {
          GridRow {
            Text("DescriptionID")
            Text(descriptionID)
          }
        }
        if let displayNameID = dogmaEffectModel.displayNameID {
          GridRow {
            Text("DisplayNameID")
            Text(displayNameID)
          }
        }
        if let dischargeAttributeID = dogmaEffectModel.dischargeAttributeID {
          GridRow {
            Text("DischargeAttributeID")
            
            AttributeInfo(attributeId: dischargeAttributeID)
          }
        }
      }
      
      ForEach(dogmaEffectModel.modifierInfo, id: \.modifiedAttributeID) { dogmaEffect in
        GridRow {
          VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
              Text("Modifying \(dogmaEffect.modifiyingAttributeID)")
              AttributeInfo(attributeId: dogmaEffect.modifiyingAttributeID)
            }.border(.yellow)
            
            HStack(alignment: .top) {
              Text("Modified \(dogmaEffect.modifiedAttributeID)")
              AttributeInfo(attributeId: dogmaEffect.modifiedAttributeID)
            }.border(.green)
            
            HStack(alignment: .top) {
              Text("SkillID")
              TypeInfo(typeId: dogmaEffect.skillTypeID)
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
      
    }.border(.red)
    
  }
}

#Preview {
  AttributeInfo(attributeId: 0)
}
