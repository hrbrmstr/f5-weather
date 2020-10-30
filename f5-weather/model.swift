//
//  model.swift
//  blah
//
//  Created by hrbrmstr on 10/28/20.
//

import Foundation

struct F5DayCast: Identifiable {
  
  var id = UUID()
  var day: String = ""
  var low: Double = 0.0
  var high: Double = 0.0
  var condition: String = ""
  
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
    
    let urlString = "https://rud.is/f5wx/conditions.json?q=\(Date().timeIntervalSince1970)"
    
    logger.info("Retrieving \(urlString)")
    
    let url = URL(string: urlString)!
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
              
        DispatchQueue.main.async {

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
          
        }
                    
      }
      
    }
    
    task.resume()
    
  }
  
}
