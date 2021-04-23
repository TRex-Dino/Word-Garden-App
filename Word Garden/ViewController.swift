//
//  ViewController.swift
//  Word Garden
//
//  Created by Dmitry on 23.04.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var wordGuessedLabel: UILabel!
    @IBOutlet var wordsMissedLabel: UILabel!
    @IBOutlet var wordsRemainingLabel: UILabel!
    @IBOutlet var wordsInGameLabel: UILabel!
    
    
    @IBOutlet var wordBeingRevealedLabel: UILabel!
    
    @IBOutlet var guessedLetterTextField: UITextField!
    @IBOutlet var guessLetterButton: UIButton!
    
    @IBOutlet var playAgainButton: UIButton!
    @IBOutlet var gameStatusMessageLabel: UILabel!
    
    @IBOutlet var flowerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
    }
}

