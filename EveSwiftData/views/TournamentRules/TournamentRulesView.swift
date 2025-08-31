//
//  TournamentRulesView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//

import SwiftData
import SwiftUI

struct TournamentRulesView: View {
  @Query var tournamentRules: [TournamentRuleSetModel]

  @State var selectedTournamentRules: TournamentRuleSetModel?
  @State private var inspectorShown = false

  var body: some View {
    VStack(alignment: .leading) {
      Text("TournamentRulesView")

      if let selectedTournamentRules {
        TournamentRulesetView(tournamentRuleSet: selectedTournamentRules)
      }
    }
    .border(.yellow)
    .onAppear {
      selectedTournamentRules = tournamentRules.first(where: {
        $0.ruleSetName == "Alliance Tournament XX"
      })
    }
    .toolbar {
      ToolbarItem {
        Menu(
          content: {
            ForEach(tournamentRules, id: \.ruleSetID) { tournamentRules in
              Button(
                action: {
                  self.selectedTournamentRules = tournamentRules
                },
                label: {
                  Text("\(tournamentRules.ruleSetName)")
                }
              ).tag(tournamentRules.ruleSetID)

              //Text(tournamentRules.name)
            }
          },
          label: {
            if let selectedTournamentRules = selectedTournamentRules {
              Text("\(selectedTournamentRules.ruleSetName)")
            } else {
              Text("Select a Tournament")
            }
          }
        )
      }
      ToolbarItem {
        Button {
          inspectorShown.toggle()
        } label: {
          Label("Inspector", systemImage: "info.circle.fill")
        }
        .buttonStyle(.borderedProminent)
      }
    }
    .inspector(isPresented: $inspectorShown) {
      if let selectedTournamentRules {
        Form {
          TournamentPointsView(points: selectedTournamentRules.points)
          LabeledContent("size", value: "")
        }
        .navigationTitle("Inspector")
      }
      
    }

  }
}

#Preview {
  TournamentRulesView()
}
