import SwiftUI


// MARK: The view for each day row

struct DayView: View {
  
  @Environment(\.colorScheme) var colorScheme

  let dayCast: F5DayCast
  let minTemp: Double
  let maxTemp: Double
  
  var body : some View {
    
    // example row:
    // Day | ##/## | icon | ##° (=================) ##°
    
    HStack {
      
      Text(dayCast.day.split(separator: " ")[0])
        .frame(width: 3*CHAR_WIDTH, height: CGFloat(ROW_HEIGHT), alignment: .center) // Day
      
      Text(dayCast.day.split(separator: " ")[1])
        .frame(width: 3*CHAR_WIDTH, height: CGFloat(ROW_HEIGHT), alignment: .center) // ##/##
      
      Image(systemName: colorScheme == .dark ? conditionToSymbol[dayCast.condition, default: "sun.max.fill"] :
              conditionToSymbolLight[dayCast.condition, default: "sun.max"]) // icon
        .renderingMode(.original) // enables color
        .font(.title3) // a bit bigger than body
        .fixedSize()
        .frame(alignment: .leading)
        .foregroundColor(conditionToSymbolColor[dayCast.condition, default: Color.yellow]) // change higlight color depending on the condition
        .accessibility(label: Text(dayCast.condition))
        .help(dayCast.condition)
      
      Spacer()
        .frame(width: CHAR_WIDTH, height: CGFloat(ROW_HEIGHT))

      Spacer() // space before first temp label
        .frame(
          width: CGFloat(dayCast.low.rescale(from: self.minTemp...self.maxTemp, to: RANGE_MIN...RANGE_MAX)-0),
          height: CGFloat(ROW_HEIGHT),
          alignment: .leading
        )
      
      Text(String(format: "%.f°",  dayCast.low)) // ##°
        .fixedSize()
        .frame(alignment: .leading)
      
      Spacer() // small space before temperature line
        .fixedSize()
        .frame(alignment: .leading)
      
      GeometryReader { g in // temperature line (=================)
        Path { path in
          let w = g.size.width
          let h = g.size.height
          path.move(to: CGPoint(x: 0, y: h/2))
          path.addLine(to: CGPoint(x:w, y: h/2))
        }
        .stroke(style: StrokeStyle(lineWidth: CGFloat(ROW_HEIGHT)/2, lineCap: .round))
        .foregroundColor(Color.primary)
        
      }.frame(
        width: CGFloat(dayCast.high.rescale(from: self.minTemp...self.maxTemp, to: RANGE_MIN...RANGE_MAX) -
                        dayCast.low.rescale(from: self.minTemp...self.maxTemp, to: RANGE_MIN...RANGE_MAX)),
        height: CGFloat(ROW_HEIGHT),
        alignment: .leading
      )
      
      Spacer() // small space after temperature line
        .fixedSize()
        .frame(alignment: .leading)
      
      Text(String(format: "%.f°",  dayCast.high)) // ##°
        .fixedSize()
        .frame(alignment: .leading)
    }
    .fixedSize()
    
  }
  
}

// MARK: The main view/window
// dynamically resize window based on the number of forecast day lines we have
struct ContentView: View {
  
  @EnvironmentObject var model: AppModel // set in f5wxApp.swift
  
  var body: some View {
    
    GeometryReader { g in // greedy view in the event we want to do more complex things
      VStack {
        ForEach(model.forecast) {
          (day) in DayView(dayCast: day, minTemp: model.minTemp, maxTemp: model.maxTemp)
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
        }
      }.padding()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification)) { _ in
      model.getForecast()
    }
    .frame(
      minWidth: VIEW_WIDTH,
      idealWidth: VIEW_WIDTH,
      maxWidth: VIEW_WIDTH,
      minHeight: model.height(),
      idealHeight: model.height(),
      maxHeight: model.height()
    )
    .alert(
      isPresented: $model.showAlert,
      content: {
        Alert(
          title : Text("Forecast Retrieval Error"),
          message: Text(model.alertMessage),
          dismissButton: .default(Text("Continue"))
        )
      })
  }
  
}
