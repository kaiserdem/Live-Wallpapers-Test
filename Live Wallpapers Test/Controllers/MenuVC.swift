//
//  SecondViewController.swift
//  Live Wallpapers Test
//
//  Created by Kaiserdem on 18.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {


  
  override func viewDidLoad() {
        super.viewDidLoad()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
    
  @IBAction func firstButtonAction(_ sender: Any) {
    showWallpapersVC("1")
  }
  
  @IBAction func secondButtonAction(_ sender: Any) {
    showWallpapersVC("2")
  }
  
  @IBAction func thirdButtonAction(_ sender: Any) {
    showWallpapersVC("3")
  }
  
  func showWallpapersVC(_ index: String) {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WallpapersID") as! WallpapersVC
    homeViewController.wallpaperIndex = index
    self.present(homeViewController, animated: true)
  }
  
}
