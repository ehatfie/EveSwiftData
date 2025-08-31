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





#Preview {
  AttributeInfo(attributeId: 0)
}
