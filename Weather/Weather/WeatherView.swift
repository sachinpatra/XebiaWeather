//
//  WeatherView.swift
//  Weather
//
//  Created by Sachin Kumar Patra on 6/14/20.
//  Copyright © 2020 Sachin Kumar Patra. All rights reserved.
//

import SwiftUI
import Alamofire


struct Weather: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var name: String
    var tempMax: String
    var tempMin: String
    var des: String
    var windSpeed: String
    var date: Date = Date()
    var dateTime: Date = Date()
}

struct WeatherView: View {
//    @State private var citiNames: String = "Bengaluru,Kolkata,Mumbai"
    @State private var citiNames: String = ""
    @State var searchResults: [Weather] = []
    
    var body: some View {
        VStack(spacing: 50.0) {
            VStack(spacing: 20.0) {
                TextField("Enter City Names", text: $citiNames)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    let queryList = self.citiNames.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
                    
                    guard (queryList.count >= 3) && (queryList.count <= 7) else {
                        Weatherutility.showAlert(withMessage: "You have to enter atlest 3 and atmost 7 citi names")
                        return
                    }
                    
                    self.searchResults = []
                    
                    queryList.forEach { (cityName) in
                        
                        AF.request("https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=2a1bf90981e862dd82a3943a6df7f2d8", method: .get, parameters: nil).responseJSON { (response) in
                            switch response.result  {
                            case .success(let value):
                                var data: [String: String] = [:]
                                if let result = value as? [String: Any] {
                                    if let message = result["message"] as? String, message == "city not found" {
                                        Weatherutility.showAlert(withMessage: message)
                                        return
                                    } else if let message = result["message"] as? String, message == "Nothing to geocode" {
                                        Weatherutility.showAlert(withMessage: message)
                                        return
                                    }
                                    
                                    if let name = result["name"] as? String {
                                        data["name"] = name
                                    }
                                    if let main = result["main"] as? [String: Any] {
                                        if let tempMax = main["temp_max"] as? Double {
                                            data["temp_max"] = "\(tempMax)"
                                        }
                                        if let tempMin = main["temp_min"] as? Double {
                                            data["temp_min"] = "\(tempMin)"
                                        }
                                    }
                                    
                                    if let wet = result["weather"] as? [[String: Any]], let weather = wet.first, let des = weather["description"] as? String {
                                        data["weth_des"] = des
                                    }
                                    
                                    if let wind = result["wind"] as? [String: Any], let speed = wind["speed"] as? Double {
                                        data["wind_speed"] = String(speed)
                                    }
                                    
                                    self.searchResults.append(Weather(name: data["name"]!, tempMax: data["temp_max"]!, tempMin: data["temp_min"]!, des: data["weth_des"]!, windSpeed: data["wind_speed"]!))
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                            
                        }
                    }

                }) {
                    Text("Submit")
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemBlue), lineWidth: 1)
                )
            }
            
            List {
                ForEach(searchResults) { (weather) in
                    Section(header: Text(weather.name)) {
                        HStack {
                            Text("Temperature")
                            Spacer()
                            Text("Max: \(weather.tempMax)").foregroundColor(.secondary)
                                Text("Max: \(weather.tempMin)").foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Weather")
                            Spacer()
                            Text(weather.des).foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Wind Speed")
                            Spacer()
                            Text(weather.windSpeed).foregroundColor(.secondary)
                        }
                    }
                   
                }
            }
        }
        .padding()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
