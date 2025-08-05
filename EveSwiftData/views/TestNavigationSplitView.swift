//
//  TestNavigationList.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/11/25.
//

import SwiftUI

struct TestNavigationSplitView: View {
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
          ShipFittingView(
            viewModel: ShipFittingViewModel(
                modelData: modelData,
                typeId: typeString.typeId
              )
            )
        //TypeDetailView(typeId: typeString.typeId, modelContext: modelData.modelContext)
      }
      .navigationDestination(for: MarketGroupString.self) { marketGroupString in
        Text("MarketGroupString \(marketGroupString.value)")
      }
      .navigationDestination(for: NavigationOptions.self) { page in
        NavigationStack(path: $modelData.path) {
          page.viewForPage()
        }

        //                .navigationDestination(for: LandmarkCollection.self) { collection in
        //                    CollectionDetailView(collection: collection)
        //                }
        //                .showsBadges()
      }
      .frame(minWidth: 150)
    } detail: {
      Text("Some Detail")
        DogmaShieldView(dogmaAttributes: [
            .init(value: 0.11, attributeId: 271, categoryId: nil, text: "EM"),
            .init(value: 0.44, attributeId: 274, categoryId: nil, text: "Thermal"),
            .init(value: 0.33, attributeId: 273, categoryId: nil, text: "Kinetic"),
            .init(value: 0.22, attributeId: 272, categoryId: nil, text: "Explosive"),
        ])
      NavigationStack(path: $modelData.path) {
        //NavigationOptions.landmarks.viewForPage()
      }
      .navigationDestination(for: IdentifiedString.self) { landmark in
        //Text("Identified string \(landmark.value)")
        //LandmarkDetailView(landmark: landmark)
      }
      //            .showsBadges()
    }
    // Adds global search, where the system positions the search bar automatically
    // in content views.
    .searchable(text: $modelData.searchString, prompt: "Search")
    // Adds the inspector, which the landmark detail view uses to display
    // additional information.
    .inspector(isPresented: $modelData.isItemInspectorPresented) {
      //            if let landmark = modelData.selectedLandmark {
      //                LandmarkDetailInspectorView(landmark: landmark, inspectorIsPresented: $modelData.isLandmarkInspectorPresented)
      //            } else {
      //                EmptyView()
      //            }
    }
  }
}
