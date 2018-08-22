//
//  ViewController.swift
//  YCRateViewSample
//
//  Created by 馮仰靚 on 2018/8/22.
//  Copyright © 2018年 larvata.YC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var ycRateView: YCRateView!

  override func viewDidLoad() {
    super.viewDidLoad()
    ycRateView.isSliderEnabled = true
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

