import Foundation

// MARK: What each forecast row holds
struct F5DayCast: Identifiable {
  
  var id = UUID()
  var day: String = "" // e.g. "Fri 10/30"
  var low: Double = 0.0 // e.g. 31
  var high: Double = 0.0 // e.g. 53
  var condition: String = "" // e.g. "Clear"
  
}

// MARK: The core model for the application
class AppModel: ObservableObject {
  
  // example individual JSON line:
  // {"V1":"Wed 10/28","V2":38,"V3":47,"conditions":"Rain","c_alpha":0.75}
  
  @Published var forecast: [F5DayCast] = [] // each day's forecast
  
  @Published var minTemp: Double = Double.infinity // we're holding the overall lowest and highest temps so we
  @Published var maxTemp: Double = -Double.infinity // can draw the lines scaled properly
  
  @Published var showAlert: Bool = false // in case there are errors
  @Published var alertMessage: String = ""
  
  init() {
    getForecast() // get the forecast right away
  }
  
  func getForecast() {
    
    if let urlBaseString = Bundle.main.object(forInfoDictionaryKey: "ForecastURL") as? String {
      
      let urlString : String = "\(urlBaseString)?q=\(Date().timeIntervalSince1970)"
      
      logger.info("Retrieving \(urlString)")
      
      if let url = URL(string: urlString) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
          
          if let error = error { // alert on error
            self.showAlert = true
            self.alertMessage = error.localizedDescription
            logger.info("Error fetching data: \(error.localizedDescription)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else { // alert on non-200 response
            self.showAlert = true
            self.alertMessage = "Received a non-200 response from the server."
            logger.info("Non-200 response.")
            return
          }
          
          if let mimeType = httpResponse.mimeType, mimeType == "application/json",
             
             let data = data,
             let res = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                  
                  let lines = res.split(whereSeparator: \.isNewline) // convert the String response to lines
                  
                  self.forecast = lines.map { line in // process JSON in each line
                    
                    let v = try? JSONDecoder().decode(JSON.self, from: line.data(using: .utf8)!)

                    if let m = v!.V2.doubleValue { // see if the day's min is the lowest we've seen
                      self.minTemp = (m < self.minTemp) ? m : self.minTemp
                    }
                    
                    if let m = v!.V3.doubleValue { // see if the day's max is the lowest we've seen
                      self.maxTemp = (m > self.maxTemp) ? m : self.maxTemp
                    }
                    
                    return( // if the records are junk but are still "records", populate the day with defaults
                      F5DayCast(
                        day: v!.V1.stringValue ?? "Day ##/##",
                        low: v!.V2.doubleValue ?? 32.0,
                        high: v!.V3.doubleValue ?? 90.0,
                        condition: v!.conditions.stringValue ?? "Clear"
                      )
                    )
                    
                  } // lines processor
                  
                } // DQ
            
          } // mimeType
          
        } // task setup
        
        task.resume()
      
      } else {
        self.showAlert = true
        self.alertMessage = "URL error"
        logger.info("URL Error")
        return
      } // URL
    } // urlString
  } // getForecast()
} // class
