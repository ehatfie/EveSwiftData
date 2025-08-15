//
//  DogmaCategoryInfo.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/24/25.
//

import SwiftData
import SwiftUI

struct DogmaCategoryInfo: View {
  @Query private var dogmaAttributeCategoryModels: [DogmaAttributeCategoryModel]
  let categoryId: Int64

  init(categoryId: Int64) {
    self.categoryId = categoryId
    _dogmaAttributeCategoryModels = Query(
      filter: DogmaAttributeCategoryModel.predicate(categoryId: categoryId)
    )
  }

  var dogmaAttributeCategoryModel: DogmaAttributeCategoryModel {
    dogmaAttributeCategoryModels[0]
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Text("\(dogmaAttributeCategoryModel.categoryId)")
        Text(dogmaAttributeCategoryModel.name)
      }

      //Text(dogmaAttributeCategoryModel.categoryDescription)

    }

  }
}

#Preview {
  DogmaCategoryInfo(categoryId: 0)
}
