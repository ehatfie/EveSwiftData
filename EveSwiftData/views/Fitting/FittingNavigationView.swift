//
//  FittingNavigationView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/9/25.
//

import SwiftUI

struct FittingNavigationView: View {
  @Environment(ModelData.self) var modelData
  @State private var preferredColumn: NavigationSplitViewColumn = .detail

  var body: some View {
    @Bindable var modelData = modelData
    NavigationSplitView(preferredCompactColumn: $preferredColumn) {
      List {
        OutlineGroup(
          modelData.sidebarItems,
          id: \.id,
          children: \.content
        ) { value in
          NavigationLink(value: (value)) {
            Text(value.value)
          }
        }
      }
      .navigationDestination(for: IdentifiedString.self) { identifiedString in
        Text("IdentifiedString \(identifiedString.value)")
      }
      .navigationDestination(for: TypeString.self) { typeString in
        //TypeDetailView(typeId: typeString.typeId, modelContext: modelData.modelContext)
      }
      .navigationDestination(for: MarketGroupString.self) { marketGroupString in
        Text("MarketGroupString \(marketGroupString.value)")
      }
    } detail: {
      //Text("Some Detail")
      //FittingRootView(viewModel: FittingViewModel(modelData: modelData))
      //        DogmaShieldView(dogmaAttributes: [
      //            .init(value: 0.11, attributeId: 271, categoryId: nil, text: "EM"),
      //            .init(value: 0.44, attributeId: 274, categoryId: nil, text: "Thermal"),
      //            .init(value: 0.33, attributeId: 273, categoryId: nil, text: "Kinetic"),
      //            .init(value: 0.22, attributeId: 272, categoryId: nil, text: "Explosive"),
      //        ])
      NavigationStack(path: $modelData.path) {
        //NavigationOptions.landmarks.viewForPage()
      }
      .navigationDestination(for: IdentifiedString.self) { landmark in
        //Text("Identified string \(landmark.value)")
        //LandmarkDetailView(landmark: landmark)
      }
      //            .showsBadges()
    }
  }
}

#Preview {
  FittingNavigationView()
}
