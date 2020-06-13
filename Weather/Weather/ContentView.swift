//
//  ContentView.swift
//  Weather
//
//  Created by Sachin Kumar Patra on 6/14/20.
//  Copyright © 2020 Sachin Kumar Patra. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeatherView()
                .tabItem{
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 22))
                    Text("Weather")
                }
            .tag(0)
            
            GpsView()
                .tabItem{
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 22))
                    Text("GPS")
                }
            .tag(1)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
