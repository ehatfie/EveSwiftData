//
//  AttributeInfo.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/14/25.
//

import SwiftData
import SwiftUI

struct AttributeInfo: View {
  @Query private var attributeModels: [DogmaAttributeModel]
  
  var attributeModel: DogmaAttributeModel? {
    guard let attributeModel = attributeModels.first else {
      return nil
    }
    return attributeModel
  }
  
  let attributeId: Int64
  init?(attributeId: Int64) {
    self.attributeId = attributeId
    self._attributeModels = Query(
      filter: DogmaAttributeModel.predicate(attributeId: attributeId)
    )
  }
  
  var body: some View {
    if let attributeModel = attributeModel {
      VStack(alignment: .leading, spacing: 5) {
        if let displayNameID = attributeModel.displayNameID {
          VStack(alignment: .leading) {
            Text("DisplayNameID")
              .font(.subheadline)
            Text(displayNameID)
          }
        }
        if let attributeDescription = attributeModel.attributeDescription, !attributeDescription.isEmpty {
          VStack(alignment: .leading) {
            Text("AttributeDescription")
              .font(.subheadline)
            Text(attributeDescription)
          }
  //        Text(attributeDescription)
  //          .fixedSize(horizontal: false, vertical: true)
        } else {
          VStack(alignment: .leading) {
            Text("AttributeDescription")
              .font(.subheadline)
            Text("")
          }.hidden()
          
        }
        if let categoryID = attributeModel.categoryID {
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
