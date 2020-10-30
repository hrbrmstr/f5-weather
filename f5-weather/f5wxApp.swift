//
//  blahApp.swift
//  blah
//
//  Created by hrbrmstr on 10/28/20.
//

import SwiftUI

var model = AppModel()

@main
struct blahApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .navigationTitle("F5 Weather • ECMWF • Berwick, Maine")
        .environmentObject(model)
    }.commands {
      CommandMenu("Utilities") {
        Button(action: {
          model.getReadings()
        }) {
          Text("Refresh")
        }.keyboardShortcut("r", modifiers: .command)
      }
    }
  }
}
