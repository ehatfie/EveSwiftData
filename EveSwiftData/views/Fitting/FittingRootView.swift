//
//  FittingRootView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/4/25.
//

import SwiftUI
import SwiftData

@Observable
class FittingViewModel {
  let modelData: ModelData
  var fittingModel: ShipFittingModel

  var textInput: String = fit2
  var loadedFit: ShipFittingModel?
  var shipFittingDisplayable: ShipFittingDisplayable?
  
  var fittingEngine: FittingEngine2
  
  init(modelData: ModelData, fittingModel: ShipFittingModel) {
    self.modelData = modelData
    self.fittingModel = fittingModel
    self.fittingEngine = FittingEngine2(
      modelContext: modelData.modelContext,
      fitting: fittingModel
    )
    makeFittingSections()
    
  }

  func importFitting() {
    let input = textInput
    Task {
      guard let result = await modelData.fittingEngine.processEFTString(input) else {
        print("++ got no result for input")
        return
      }
      //self.loadedFit = result
      self.save(item: result)
      makeFittingSections()
    }
    return
    //print("Output \(output)")
  }
  
  func makeFittingSections() {
    self.shipFittingDisplayable = fittingEngine.makeShipFittingDisplayable(
      fittingModel
    )
  }
  
  func save(item: ShipFitting) {
    let modelContext = modelData.modelContext
    let model = ShipFittingModel(fitting: item)
    do {
      modelContext.insert(model)
      try modelContext.save()
    } catch let error {
      print("++ error saving item \(item) \(error)")
    }
  }
}

struct FittingRootView: View {
  @State var viewModel: FittingViewModel

  var body: some View {
    VStack {
      Text("FittingRootView")
      Grid(alignment: .top) {
        if let fitting = viewModel.shipFittingDisplayable {
          GridRow(alignment: .top) {
            FittingDetailView(data: fitting).border(.red)
            FittingStatsView(dogmaAttributes: viewModel.fittingEngine.modifiedCategorizedDogmaAttributes)
          }
          GridRow {
            //DogmaShieldView(dogmaAttributes: fittingEngine.dogma)
              TypeDetailView(
                typeId: viewModel.fittingModel.shipTypeID,
                modelContext: viewModel.modelData.modelContext
              )
          }
        }
      }.border(.blue)
        .padding()
      Spacer()
    }
  }

  func textInput() -> some View {
    VStack {
      Text("Text Input")
      TextEditor(text: $viewModel.textInput)
        .frame(maxWidth: 500)
      Button("Submit") {
        viewModel.importFitting()
      }
    }
    .frame(maxWidth: 500)
    .border(.red)
  }
}
