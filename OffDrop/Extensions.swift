//
//  Extensions.swift
//  OffDrop
//
//  Created by Utku Kaan Gülsoy on 2.08.2025.
//

import UIKit

extension UIViewController {
    static func instantiate(fromStoryboard name: String = "Main") -> Self {
        func instantiateVC<T: UIViewController>() -> T {
            let storyboard = UIStoryboard(name: name, bundle: nil)
            let identifier = String(describing: self)
            return storyboard.instantiateViewController(withIdentifier: identifier) as! T
        }
        return instantiateVC()
    }
}

