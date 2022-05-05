//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by JPL-ST-SPRING2022 on 5/4/22.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    // custom label from cocapod
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleText = K.appName

        titleLabel.text = titleText

    }
}
