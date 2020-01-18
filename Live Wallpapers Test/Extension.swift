//
//  Extension.swift
//  Live Wallpapers Test
//
//  Created by Kaiserdem on 18.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//
import UIKit

extension UIViewController {
  
  func postAlert(_ title: String) {
    
    DispatchQueue.main.async(execute: { () -> Void in
      
      let alert = UIAlertController(title: title, message: nil,
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      
      let popOver = alert.popoverPresentationController
      popOver?.sourceView  = self.view
      popOver?.sourceRect = self.view.bounds
      popOver?.permittedArrowDirections = UIPopoverArrowDirection.any
      
      self.present(alert, animated: true, completion: nil)
      
    })
    
  }
}
