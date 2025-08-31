//
//  TournamentRulesetView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//

import SwiftUI

struct TournamentRulesetView: View {
  var tournamentRuleSet: TournamentRuleSetModel
  var body: some View {
    Grid(alignment: .leading) {
      GridRow {
        Text(tournamentRuleSet.ruleSetName)
      }
      GridRow {
        HStack {
          Text("Maximum Pilots")
          Text("\(tournamentRuleSet.maximumPilotsMatch)")
        }
      }
      GridRow {
        HStack {
          Text("Maximum Points")
          Text("\(tournamentRuleSet.maximumPointsMatch)")
        }
      }
//      HStack {
//        Spacer()
//        ScrollView {
//          VStack(alignment: .leading) {
//            TournamentPointsView(points: tournamentRuleSet.points)
//          }
//        }
//      }
//      GridRow {
//        //TournamentBannedView(banned: tournamentRuleSet.banned)
//       
//      }
      
    }.border(.orange)
    
  }
}

#Preview {
  TournamentRulesetView(
    tournamentRuleSet: TournamentRuleSetModel(
      data: TournamentRulesData(
        banned: TournamentRulesBannedData(
          groups: [],
          types: []
        ),
        maximumPilotsMatch: 10,
        maximumPointsMatch: 100,
        points: TournamentRulesPointsCategoryData(
          groups: [],
          types: [])
        ,
        ruleSetID: "TestID",
        ruleSetName: "Test Rule Set"
      )
    )
  )
}
