//
//  ContentView.swift
//  blah
//
//  Created by hrbrmstr on 10/28/20.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var model: AppModel

  var body: some View {
    VStack {
      List {
        ForEach(model.readings) {
          (r) in DayView(reading: r, min: model.min, max: model.max)
        }
      }
    }.frame( minWidth: 528,  idealWidth: 528,  maxWidth: 528,
            minHeight: 256, idealHeight: 330, maxHeight: 330)
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
      Image(systemName: etab[reading.condition, default: "sun.max.fill"])
        .renderingMode(.original)
        .font(.title3)
        .frame(width: 3*12, height: HEIGHT, alignment: .center)
        .foregroundColor(ecol[reading.condition, default: Color.yellow])
      Spacer().frame(width: CGFloat(reading.low.rescale(from: self.min...self.max, to: DOMAIN_MIN...DOMAIN_MAX)-0),
                     height: HEIGHT, alignment: .leading)
      Text(String(format: "%.f°",  reading.low)).frame(width: 2*12, height: HEIGHT, alignment: .trailing)
      Spacer().frame(width: 10.0, height: HEIGHT, alignment: .leading)
      GeometryReader { g in
        Path { path in
          let w = g.size.width
          let h = g.size.height
          path.move(to: CGPoint(x: 0, y: h/2))
          path.addLine(to: CGPoint(x:w, y: h/2))
        }.stroke(style: StrokeStyle(lineWidth: HEIGHT/2, lineCap: .round)).foregroundColor(Color.primary)
      }.frame(width: CGFloat(reading.high.rescale(from: self.min...self.max, to: DOMAIN_MIN...DOMAIN_MAX) -
                              reading.low.rescale(from: self.min...self.max, to: DOMAIN_MIN...DOMAIN_MAX)),
              height: HEIGHT, alignment: .leading)
      Spacer().frame(width: 10.0, height: HEIGHT, alignment: .leading)
      Text(String(format: "%.f°",  reading.high)).frame(width: 2*12, height: HEIGHT, alignment: .leading)
    }
    
  }
}


