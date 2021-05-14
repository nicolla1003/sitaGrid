//
//  Storyboarded.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 12.5.21..
//

import UIKit

public protocol Storyboarded {
    static var storyboardName: String { get set }
    static func instantiate() -> Self
}

public extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
