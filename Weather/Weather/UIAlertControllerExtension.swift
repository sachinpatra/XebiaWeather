//
//  UIAlertControllerExtension.swift
//  
//
//  Created by Sachin Kumar Patra on 6/14/20.
//

import UIKit

extension UIAlertController {
    
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: animated, completion: completion)
        }
    }
    
    @discardableResult
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        
        // button image
        if let image = image {
            action.setValue(image, forKey: "image")
        }
        
        // button title color
        if let color = color {
            action.setValue(color, forKey: "titleTextColor")
        }
        
        addAction(action)
        
        return action
    }
}

