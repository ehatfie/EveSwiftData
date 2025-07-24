//
//  ShipFittingView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/21/25.
//

import SwiftUI


@Observable
class ShipFittingViewModel {
    let modelData: ModelData
    
    init(modelData: ModelData) {
        self.modelData = modelData
    }
}

struct ShipFittingView: View {
    @State var viewModel: ShipFittingViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    ShipFittingView()
//}
