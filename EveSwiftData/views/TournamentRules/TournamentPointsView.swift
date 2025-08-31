//
//  TournamentPointsView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//

import SwiftUI

struct TournamentPointsView: View {
  var points: TournamentRulesPointsModel
  var body: some View {

    ForEach(
      points.types.sorted(by: { $0.points > $1.points }),
    ) { typePoints in
      //LabeledContent("\(typePoints.typeID)", value: " \(typePoints.points)")
      LabeledContent(
        content: {
          Text("\(typePoints.points)")
        },
        label: {
          TypeInfo(typeId: typePoints.typeID)
          
        }
      )
    }  //.frame(maxWidth: 250)

  }
}

#Preview {
  TournamentPointsView(
    points: TournamentRulesPointsModel(
      data: TournamentRulesPointsCategoryData(
        groups: [],
        types: []
      )
    )
  )
}
