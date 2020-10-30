import SwiftUI

// MARK: The view for each day row

struct DayView: View {
  
  let dayCast: F5DayCast
  let minTemp: Double
  let maxTemp: Double
  
  var body : some View {
    
    // example row:
    // Day | ##/## | icon | ##° (=================) ##°
    
    HStack {
      
      Text(dayCast.day.split(separator: " ")[0])
        .frame(width: 3*CHAR_WIDTH, height: HEIGHT, alignment: .center) // Day
      
      Text(dayCast.day.split(separator: " ")[1])
        .frame(width: 3*CHAR_WIDTH, height: HEIGHT, alignment: .center) // ##/##
      
      Image(systemName: conditionToSymbol[dayCast.condition, default: "sun.max.fill"]) // icon
        .renderingMode(.original) // enables color
        .font(.title3) // a bit bigger than body
        .frame(width: 3*CHAR_WIDTH, height: HEIGHT, alignment: .center)
        .foregroundColor(conditionToSymbolColor[dayCast.condition, default: Color.yellow]) // change higlight color depending on the condition
      
      Spacer() // space before first temp label
        .frame(
        width: CGFloat(dayCast.low.rescale(from: self.minTemp...self.maxTemp, to: RANGE_MIN...RANGE_MAX)-0),
        height: HEIGHT,
        alignment: .leading
      )
      
      Text(String(format: "%.f°",  dayCast.low)) // ##°
        .frame(width: 3*CHAR_WIDTH, height: HEIGHT, alignment: .trailing)
      
      Spacer() // small space before temperature line
        .frame(width: CHAR_WIDTH, height: HEIGHT, alignment: .leading)
      
      GeometryReader { g in // temperature line (=================)
        Path { path in
          let w = g.size.width
          let h = g.size.height
          path.move(to: CGPoint(x: 0, y: h/2))
          path.addLine(to: CGPoint(x:w, y: h/2))
        }
        .stroke(style: StrokeStyle(lineWidth: HEIGHT/2, lineCap: .round))
        .foregroundColor(Color.primary)
        
      }.frame(
        width: CGFloat(dayCast.high.rescale(from: self.minTemp...self.maxTemp, to: RANGE_MIN...RANGE_MAX) -
                        dayCast.low.rescale(from: self.minTemp...self.maxTemp, to: RANGE_MIN...RANGE_MAX)),
        height: HEIGHT,
        alignment: .leading
      )
      
      Spacer() // small space after temperature line
        .frame(width: CHAR_WIDTH, height: HEIGHT, alignment: .leading)
      
      Text(String(format: "%.f°",  dayCast.high)) // ##°
        .frame(width: 3*CHAR_WIDTH, height: HEIGHT, alignment: .leading)
    }
    
  }
  
}

// MARK: The main view/window

struct ContentView: View {
  
  @EnvironmentObject var model: AppModel // set in f5wxApp.swift
  
  var body: some View {
    
    GeometryReader { g in // greedy view in the event we want to do more complex things
      VStack {
        List { // list view for each day forecast
          ForEach(model.forecast) {
            (day) in DayView(dayCast: day, minTemp: model.minTemp, maxTemp: model.maxTemp)
          }
        }
      }
    }
    .frame(
      minWidth: VIEW_WIDTH,
      idealWidth: VIEW_WIDTH,
      maxWidth: VIEW_WIDTH,
      minHeight: VIEW_MIN_HEIGHT,
      idealHeight: CGFloat((model.forecast.count > 0 ? model.forecast.count : MAX_ROWS) * ROW_HEIGHT), // dynamically resize window based on the number of forecast day lines we have
      maxHeight: CGFloat(MAX_ROWS * ROW_HEIGHT)
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
