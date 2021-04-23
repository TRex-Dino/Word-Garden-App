//
//  ViewController.swift
//  Word Garden
//
//  Created by Dmitry on 23.04.2021.
//

import UIKit
import AVFoundation

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
    
    var wordsToGuess = ["SWIFT", "DOG", "APPLE"]
    var currentIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterTextField.text!
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentIndex]
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        updateGameStatusLabels()
    }
    
    func updateUIAfterGuess() {
        //this dismisses the keyboard
        guessedLetterTextField.resignFirstResponder()
        guessedLetterTextField.text = ""
        guessLetterButton.isEnabled = false
    }
    
    func formatRevealedWord() {
        //format and show revealedWord in wordBeingRevealedLabel to include new guess
        var revealedWord = ""
        
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord += "\(letter) "
            } else {
                revealedWord += "_ "
            }
        }
        revealedWord.removeLast()
        wordBeingRevealedLabel.text = revealedWord
    }
    
    func updateAfterWinsOrLose() {
        currentIndex += 1
        guessedLetterTextField.isEnabled = false
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        
        updateGameStatusLabels()
    }
    
    func updateGameStatusLabels() {
        //update labels at top of screen
        wordGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = " Words to Guess: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
    }
    
    func guessALetter() {
        //get current letter guessed and add it to all lettersGuessed
        let currentLetterGuessed = guessedLetterTextField.text ?? ""
        lettersGuessed = lettersGuessed + currentLetterGuessed
        
        formatRevealedWord()
        //update image, if needed, and keep track of wrong guesses
        if wordToGuess.contains(currentLetterGuessed) == false {
            wrongGuessesRemaining = wrongGuessesRemaining - 1
            flowerImageView.image = UIImage(named: "flower\(wrongGuessesRemaining)")
            playSound(name: "incorrect")
        } else {
            playSound(name: "correct")
        }
        //update gameStatusMessageLabel
        guessCount += 1
        let guesses = (guessCount == 1 ? "Guess" : "Guesses")
        gameStatusMessageLabel.text = "You've Made \(guessCount) \(guesses)."
        
        // Check for win or lose
        if wordBeingRevealedLabel.text!.contains("_") == false {
            gameStatusMessageLabel.text = "You've guessed it! It took you \(guessCount) guesses to guess the word."
            wordsGuessedCount += 1
            playSound(name: "word-guessed")
            updateAfterWinsOrLose()
        } else if wrongGuessesRemaining == 0 {
            gameStatusMessageLabel.text = "So sorry. You're all out of guesses"
            wordsMissedCount += 1
            playSound(name: "word-not-guessed")
            updateAfterWinsOrLose()
        }
        
        //check to see if you've played all the words. If so, update the message indicating the player can restart the entire game.
        if currentIndex == wordsToGuess.count {
            gameStatusMessageLabel.text! += "\n\nYou've tried all of the words! Restart from the begining?"
        }
    }
    
    func playSound(name: String) {
        if let sound = NSDataAsset(name: name) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("Error \(error.localizedDescription)")
            }
        } else {
            print("Error with data \(name)")
        }
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        //if all words have been guessed and you select playAgain, then restart all games as if the app has been restarted
        if currentIndex == wordsToGuess.count {
            currentIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
        }
        playAgainButton.isHidden = true
        guessedLetterTextField.isEnabled = true
        guessLetterButton.isEnabled = false
        wordToGuess = wordsToGuess[currentIndex]
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        //create word with underscores, one for each space
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        guessCount = 0
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuesses)")
        lettersGuessed = ""
        updateGameStatusLabels()
        gameStatusMessageLabel.text = "You've Made Zero Guesses"
    }
    
    
}

