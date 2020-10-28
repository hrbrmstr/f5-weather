//
//  ContentView.swift
//  blah
//
//  Created by hrbrmstr on 10/28/20.
//

import SwiftUI

let DOMAIN_MIN: Double = 0
let DOMAIN_MAX: Double = 300
let HEIGHT: CGFloat = 20

let etab: [String: String] = [
  "Rain" : ":cloud_rain:".emojiUnescapedString,
  "Snow" : ":cloud_snow:".emojiUnescapedString,
  "Clear" : ":sunny:".emojiUnescapedString,
]

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
    }
  }
}

struct ContentView: View {
  
  @ObservedObject var model = AppModel()
    
  var body: some View {
    VStack {
      List {
        ForEach(model.readings) {
          (r) in DayView(reading: r, min: model.min, max: model.max)
        }
      }.frame(width: 540, height: 330, alignment: .topLeading)
    }
  }
}

struct DayView: View {
  
  let reading: F5DayCast
  let min: Double
  let max: Double
  
  var body : some View {
    
    HStack {
      Text(reading.day.split(separator: " ")[0]).frame(width: 3*12, height: HEIGHT, alignment: .center)
      Text(reading.day.split(separator: " ")[1]).frame(width: 3*12, height: HEIGHT, alignment: .center)
      Text(etab[reading.condition, default: "Clear"]).frame(width: 2*12, height: HEIGHT, alignment: .center)
      Spacer().frame(width: CGFloat(reading.low.rescale(from: self.min...self.max, to: DOMAIN_MIN...DOMAIN_MAX)-0),
                     height: HEIGHT, alignment: .leading)//.background(Color.red)
      Text(String(format: "%.f°F",  reading.low)).frame(width: 3*12, height: HEIGHT, alignment: .trailing)
      Spacer().frame(width: 10.0, height: HEIGHT, alignment: .leading)
      GeometryReader { g in
        Path { path in
          let w = g.size.width
          let h = g.size.height
          path.move(to: CGPoint(x: 0, y: h/2))
          path.addLine(to: CGPoint(x:w, y: h/2))
        }.stroke(style: StrokeStyle(lineWidth: HEIGHT/2, lineCap: .round)).foregroundColor(Color.primary)
      }.frame(width: CGFloat(reading.high.rescale(from: self.min...self.max, to: DOMAIN_MIN...DOMAIN_MAX)-reading.low.rescale(from: self.min...self.max, to: DOMAIN_MIN...DOMAIN_MAX)),
              height: HEIGHT, alignment: .leading)
      Spacer().frame(width: 10.0, height: HEIGHT, alignment: .leading)
      Text(String(format: "%.f°F",  reading.high)).frame(width: 3*12, height: HEIGHT, alignment: .leading)
    }
    
  }
}

struct F5DayCast: Identifiable {
  
  var id = UUID()
  var day: String = ""
  var low: Double = 0.0
  var high: Double = 0.0
  var condition: String = ""
  
}

extension Double {
  func rescale(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
    let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
    let y = (input.upperBound - input.lowerBound)
    return x / y + output.lowerBound
  }
}

extension FloatingPoint {
  func rescale(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
    let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
    let y = (input.upperBound - input.lowerBound)
    return x / y + output.lowerBound
  }
}

extension BinaryInteger {
  func rescale(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
    let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
    let y = (input.upperBound - input.lowerBound)
    return x / y + output.lowerBound
  }
}

class AppModel: NSObject, ObservableObject {
  
  // {"V1":"Wed 10/28","V2":38,"V3":47,"conditions":"Rain","c_alpha":0.75}
  
  @Published var readings: [F5DayCast] = []
  @Published var min: Double = Double.infinity
  @Published var max: Double = -Double.infinity
  
  override init() {
    super.init()
    getReadings()
  }
  
  func getReadings() {
    
    let url = URL(string: "https://tycho/data/f5.json")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      if let error = error {
        debugPrint("Error fetching data: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else { return }
      
      if let mimeType = httpResponse.mimeType, mimeType == "application/json",
         
         let data = data,
         let res = String(data: data, encoding: .utf8) {
        
        let lines = res.split(whereSeparator: \.isNewline)
        
        self.readings = lines.map { line in
          
          let v = try? JSONDecoder().decode(JSON.self, from: line.data(using: .utf8)!)
          
          if let m = v!.V2.doubleValue {
            self.min = (m < self.min) ? m : self.min
          }
          
          if let m = v!.V3.doubleValue {
            self.max = (m > self.max) ? m : self.max
          }
          
          return(
            F5DayCast(
              day: v!.V1.stringValue ?? "ERROR",
              low: v!.V2.doubleValue ?? -1.0,
              high: v!.V3.doubleValue ?? -1.0,
              condition: v!.conditions.stringValue ?? "ERROR"
            )
          )
          
        }
        
        debugPrint(24.rescale(from: self.min...self.max, to: 0...200))
        debugPrint(57.rescale(from: self.min...self.max, to: 0...200))
        debugPrint(30.rescale(from: self.min...self.max, to: 0...200))
        
      }
      
    }
    
    task.resume()
    
  }
  
}
