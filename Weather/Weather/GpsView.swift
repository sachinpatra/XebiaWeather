//
//  GpsView.swift
//  Weather
//
//  Created by Sachin Kumar Patra on 6/14/20.
//  Copyright © 2020 Sachin Kumar Patra. All rights reserved.
//

import SwiftUI
import SwiftLocation
import Alamofire

struct GpsView: View {
    @State private var currentCity: String = ""
    @State var searchResults: [(Date, [Weather])] = []

    var body: some View {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .full
        
        let timeFormatter = DateFormatter()
        //timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .full
        
        return NavigationView {
            List {
                Section {
                    HStack {
                        Text("Current City")
                        Spacer()
                        Text(currentCity).foregroundColor(.secondary)
                    }
                }
                
                if !self.searchResults.isEmpty {
                    ForEach(0..<searchResults.count) { (index) in
                        Section(header: Text(displayFormatter.string(from: self.searchResults[index].0))) {
                            ForEach(self.searchResults[index].1) { (weather) in
                                HStack {
                                    Spacer()
                                    Text(timeFormatter.string(from: weather.dateTime))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                    Spacer()
                                }
                                
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
            }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Forecast")
        }
        .onAppear {
            LocationManager.shared.locateFromGPS(.oneShot, accuracy: .city) { result in
              switch result {
                case .failure(let error):
                  debugPrint("Received error: \(error)")
                case .success(let location):
                    LocationManager.shared.locateFromCoordinates(location.coordinate, service: .apple(GeocoderRequest.Options())) { result in
                      switch result {
                        case .failure(let error):
                          debugPrint("An error has occurred: \(error)")
                        case .success(let places):
                            if let place = places.first {
                                self.currentCity = place.city ?? ""
                                self.fetchForecastData(place.city ?? "")
                            }
                      }
                    }
              }
            }
        }
    }
    
    func fetchForecastData(_ cityName: String) {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        AF.request("https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=2a1bf90981e862dd82a3943a6df7f2d8", method: .get, parameters: nil).responseJSON { (response) in
            switch response.result  {
            case .success(let value):
                if let result = value as? [String: Any] {
                    var weatherResults: [Weather] = []

                    if let list = result["list"] as? [[String: Any]] {
                        list.forEach { (forecast) in
                            var data: [String: Any] = [:]
                            if let dateString = forecast["dt_txt"] as? String {
                                if let date = dateTimeFormatter.date(from: dateString) {
                                    data["dateTime"] = date
                                }
                                
                                if let date = dateFormatter.date(from: String(dateString.prefix(10))) {
                                    data["date"] = date
                                }
                            }
                            
                            if let main = forecast["main"] as? [String: Any] {
                                if let tempMax = main["temp_max"] as? Double {
                                    data["temp_max"] = "\(tempMax)"
                                }
                                if let tempMin = main["temp_min"] as? Double {
                                    data["temp_min"] = "\(tempMin)"
                                }
                            }
                            
                            if let wet = forecast["weather"] as? [[String: Any]], let weather = wet.first, let des = weather["description"] as? String {
                                data["weth_des"] = des
                            }
                            
                            if let wind = forecast["wind"] as? [String: Any], let speed = wind["speed"] as? Double {
                                data["wind_speed"] = String(speed)
                            }
                            
                            weatherResults.append(Weather(name: "", tempMax: data["temp_max"] as! String, tempMin: data["temp_min"] as! String, des: data["weth_des"] as! String, windSpeed: data["wind_speed"] as! String, date: data["date"] as! Date, dateTime: data["dateTime"] as! Date))

                        }
                    }
                    self.searchResults.removeAll()
                    
                    let groupDic = Dictionary(grouping: weatherResults) { $0.date }
                    
                    let finealResult = groupDic.sorted { $0.key < $1.key }
                    
                    finealResult.forEach { (key, value: [Weather]) in
                        self.searchResults.append((key, value))
                    }
                   
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}

struct GpsView_Previews: PreviewProvider {
    static var previews: some View {
        GpsView()
    }
}
