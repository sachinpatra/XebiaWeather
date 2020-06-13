//
//  WeatherView.swift
//  Weather
//
//  Created by Sachin Kumar Patra on 6/14/20.
//  Copyright © 2020 Sachin Kumar Patra. All rights reserved.
//

import SwiftUI

struct WeatherView: View {
    @State private var citiNames: String = ""
        
    var body: some View {
        VStack(spacing: 50.0) {
            VStack(spacing: 20.0) {
                TextField("Enter City Names", text: $citiNames)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                Button(action: {
                    
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
                HStack {
                    Text("Temperature")
                    Spacer()
                }
                HStack {
                    Text("Weather")
                    Spacer()
                }
                HStack {
                    Text("Wind Speed")
                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
