//
//  Weatherutility.swift
//  Weather
//
//  Created by Sachin Kumar Patra on 6/14/20.
//  Copyright © 2020 Sachin Kumar Patra. All rights reserved.
//

import UIKit

class Weatherutility {
    class func showAlert(withMessage message: String, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(title: "OK")
        alert.show()
    }
}

