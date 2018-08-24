//
//  ViewController.swift
//  YCReteView
//
//  Created by stormy.petrel@msa.hinet.net on 08/24/2018.
//  Copyright (c) 2018 stormy.petrel@msa.hinet.net. All rights reserved.
//

import UIKit
import YCReteView

class ViewController: UIViewController {

  @IBOutlet weak var ycRateView: YCRateView!

  override func viewDidLoad() {
    super.viewDidLoad()
    ycRateView.initValue = 3
    ycRateView.isTextHidden = false
    ycRateView.isSliderEnabled = true
    ycRateView.textSize = 20
    // Do any additional setup after loading the view, typically from a nib.
    ycRateView.sliderAddTarget(target: self, selector: #selector(doSomething), event: .valueChanged)
  }


  @objc func doSomething(sender: UISlider) {
    print("slider value: \(sender.value)")
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

