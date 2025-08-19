//
//  AttributeCategoryList.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/18/25.
//

import SwiftUI

struct AttributeCategoryList: View {
  @Binding var attributeCategories: [AttributeCategoryValue]
  
  var body: some View {
    Grid(alignment: .topLeading, horizontalSpacing: 5) {
      //LazyVGrid(columns: adaptiveColumn) {
        ForEach(attributeCategories) { attributeCategory in
            DogmaCategoryInfo(categoryId: attributeCategory.categoryId)
            //Grid(alignment: .topLeading) {
              ForEach(attributeCategory.attributeValues) { attributeValue in
                GridRow(alignment: .top) {
                  //Text("\(attributeValue.attributeId)")
                  Text(
                    attributeValue.text + " \(attributeValue.attributeId)"
                  )
                  //AttributeInfo(attributeId: attributeValue.attributeId)
                  Text(String(format: "%.2f", attributeValue.value))  //attributeValue.value
                }//.border(.yellow)
              }
          Divider()
            .gridCellUnsizedAxes(.horizontal)
            //}
          
        }
        
      //}
    }
  }
}

#Preview {
  AttributeCategoryList(
    attributeCategories: Binding(
      get: { [] },
      set: { _ in }
    )
  )
}
