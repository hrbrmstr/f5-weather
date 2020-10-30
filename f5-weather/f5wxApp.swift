import SwiftUI

var model = AppModel() // initialize the app model

@main
struct f5wxApp: App {
  
  typealias MenuItem = Button // (not rly thrilled SwiftUI uses "Button" for menu things)
  
  var body: some Scene {
    
    WindowGroup {
      
      ContentView()
        .navigationTitle("F5 Weather • ECMWF • Berwick, Maine") // set a title for the app
        .environmentObject(model) // place our initialized app model into the Environment
        .fixedSize() // set window to fixed size so we can programmatically resize it
      
    }.commands {
      
      CommandMenu("Tools") { // add a "Tools" menu
        MenuItem(action: { // Add a menu item and shortcut that will grab new forecast data
          model.getForecast()
        }) {
          Text("Refresh")
        }.keyboardShortcut("r", modifiers: .command)
      }
      
    }
    
  }
  
}
