//
//  StartScreen.swift
//  Play Soccer
//
//  Created by Oran on 16/07/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var service = GameViewController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = """
Game instructions:
        
You must score 20 goals within 20 seconds.
"""
    }
    
    @IBAction func startGameButton(_ sender: Any) {
        service.startGame()
    }
}

