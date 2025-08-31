//
//  TournamentBannedView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//

import SwiftUI

struct TournamentBannedView: View {
  var banned: TournamentRulesBannedModel
  
  @State var expanded: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        Text("Banned List")
          .font(.headline)
          .padding(.bottom, 5)
        
        Image(systemName: expanded ? "chevron.up" :"chevron.down")
      }.onTapGesture {
        expanded.toggle()
      }
      if expanded {
        List(banned.types, id: \.self) { typeID in
          TypeInfo(typeId: typeID)
        }
        .listStyle(.plain)
        .frame(maxWidth: 300)
        .frame(height: 500)
      }
      Spacer()
    }
  }
}

#Preview {
  TournamentBannedView(
    banned: TournamentRulesBannedModel(
      data: TournamentRulesBannedData(
        groups: [],
        types: []
      )
    )
  )
}
