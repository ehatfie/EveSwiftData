//
//  GroupInfo.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//

import SwiftUI
import SwiftData

struct GroupInfo: View {
  @Query private var groupModels: [GroupModel]
  
  var groupModel: GroupModel {
    groupModels.first ?? GroupModel(
      groupId: 0,
      groupData: GroupData(
        id: 0,
        name: "Name"
      )
    )
  }
  
  init(groupId: Int64) {
    self._groupModels = Query(
      filter: GroupModel.predicate(groupId: groupId)
    )
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(groupModel.name)
    }
  }
}
