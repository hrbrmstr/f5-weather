import SwiftUI

var model = AppModel() // initialize the app model

// MARK: Settings are a WIP

struct GeneralSettingsView: View {
  @AppStorage("maxUpdateFrequency") private var maxUpdateFrequency = 360.0
  
  var body: some View {
    Form {
      Slider(value: $maxUpdateFrequency, in: 360...2160, step:60) {
        Text("Update Frequency\n(\(maxUpdateFrequency, specifier: "%f.") seconds)")
      }
    }
    .padding(20)
    .frame(width: 350, height: 100)
  }
}

struct SettingsView: View {
  private enum Tabs: Hashable {
    case general, advanced
  }
  var body: some View {
    TabView {
      GeneralSettingsView()
        .tabItem {
          Label("General", systemImage: "gear")
        }
        .tag(Tabs.general)
    }
    .padding(20)
    .frame(width: 375, height: 150)
  }
}

@main
struct f5wxApp: App {
  
  typealias MenuItem = Button // (not rly thrilled SwiftUI uses "Button" for menu things)
  
  var body: some Scene {
    
    WindowGroup {
      
      ContentView()
        .navigationTitle("F5 Weather • ECMWF • Berwick, Maine") // set a title for the app
        .environmentObject(model) // place our initialized app model into the Environment
        .fixedSize() // set window to fixed size so we can programmatically resize it
    }
    .windowStyle(TitleBarWindowStyle())
    .commands {
      
      CommandMenu("Tools") { // add a "Tools" menu
        MenuItem(action: { // Add a menu item and shortcut that will grab new forecast data
          model.getForecast(force: true)
        }) {
          Text("Refresh")
        }.keyboardShortcut("r", modifiers: .command)
      }
      
    }
        
    #if os(macOS)
    Settings {
      SettingsView()
    }
    #endif

  }
  
}
