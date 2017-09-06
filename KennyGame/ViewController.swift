//
//  ViewController.swift
//  KennyGame
//
//  Created by Engin Yüce on 21.08.2017.
//  Copyright © 2017 Engin Yüce. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let startButton = UIButton()
    let imageView = UIImageView()
    var timer = Timer()

    let MAX_COUNT: Int = 10
    var counter: Int = 0
    var bestScore: Int = 0
    var currentScore: Int = 0
    
    var winWidth: CGFloat = 0
    var winHeight: CGFloat = 0
    var pictSize: CGFloat = 0
    
    var pictPost: UInt32 = 0

    @IBAction func resetButtonTouched(_ sender: Any) {

        timer.invalidate()
        resetAlert(title: "Reset Which One?", message: "Please Select One:")

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        winWidth = view.frame.size.width
        winHeight = view.frame.size.height
        pictSize = winWidth * winHeight * 0.0004

        startButton.setTitle("Start Game!", for: UIControlState.normal)
        startButton.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        startButton.frame = CGRect.init(x: 0, y: winHeight * 0.5, width: winWidth, height: 20)
        startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControlEvents.touchUpInside)

        imageView.image = UIImage(named: "Kenny.jpg")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2, y: (winHeight - pictSize) / 2, width: pictSize, height: pictSize)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.pictureTouched)))

        imageView.isHidden = true
        startButton.isHidden = true

        view.addSubview(imageView)
        view.addSubview(startButton)

        if let bestScore = UserDefaults.standard.object(forKey: "bestScore") as? Int {
            self.bestScore = bestScore
        }
        else {
            bestScore = 0
        }

        resetCurrentGame()

    }

    @objc func startButtonTouched(_ sender: Any) {

        counter = MAX_COUNT
        remainingLabel.text = "Remaining: " + String(counter)
        progressView.progress = 1.0

        imageView.isHidden = false
        startButton.isHidden = true

        startTimer()
    }

    @objc func timerFunc(_ sender: Any) {

        counter -= 1

        remainingLabel.text = "Remaining: " + String(counter)
        progressView.progress = Float(counter) / Float(MAX_COUNT)
        if counter <= 0 {
            endGame()
        }

    }
    
    @objc func pictureTouched() {

        currentScore += 1
        scoreLabel.text = "Score: " + String(currentScore)
        
        var random = arc4random_uniform(8)
        while pictPost == random % 9 {
            random = arc4random_uniform(8)
        }
        pictPost = random % 9
        
        if pictPost == 0 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2, y: (winHeight - pictSize) / 2, width: pictSize, height: pictSize)
        }
        else if pictPost == 1 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2, y: (winHeight - pictSize) / 2 - pictSize * 1.2, width: pictSize, height: pictSize)
        }
        else if pictPost == 2 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2, y: (winHeight - pictSize) / 2 + pictSize * 1.2, width: pictSize, height: pictSize)
        }
        else if pictPost == 3 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2 - pictSize * 1.2, y: (winHeight - pictSize) / 2 - pictSize * 1.2, width: pictSize, height: pictSize)
        }
        else if pictPost == 4 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2 - pictSize * 1.2, y: (winHeight - pictSize) / 2, width: pictSize, height: pictSize)
        }
        else if pictPost == 5 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2 - pictSize * 1.2, y: (winHeight - pictSize) / 2 + pictSize * 1.2, width: pictSize, height: pictSize)
        }
        else if pictPost == 6 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2 + pictSize * 1.2, y: (winHeight - pictSize) / 2 - pictSize * 1.2, width: pictSize, height: pictSize)
        }
        else if pictPost == 7 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2 + pictSize * 1.2, y: (winHeight - pictSize) / 2, width: pictSize, height: pictSize)
        }
        else if pictPost == 8 {
            imageView.frame = CGRect.init(x: (winWidth - pictSize) / 2 + pictSize * 1.2, y: (winHeight - pictSize) / 2 + pictSize * 1.2, width: pictSize, height: pictSize)
        }

    }

    func startTimer() {

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerFunc), userInfo: nil, repeats: true)

    }

    func resetCurrentGame() {

        pictPost = 0
        currentScore = 0
        bestLabel.text = "Best: " + String(bestScore)
        scoreLabel.text = "Score: 0"
        remainingLabel.text = "Remaining: 0"
        progressView.progress = 0.0
        timer.invalidate()

        imageView.isHidden = true
        startButton.isHidden = false

    }

    func clearBestScore(){

        bestScore = 0
        startButton.setTitle("Start Game!", for: UIControlState.normal)

        if (UserDefaults.standard.object(forKey: "bestScore") as? Int) != nil {
            UserDefaults.standard.removeObject(forKey: "bestScore")
        }
        UserDefaults.standard.synchronize()

        resetCurrentGame()

    }

    func endGame(){

        startButton.setTitle("Score: " + String(currentScore) + ", Start Again?", for: UIControlState.normal)
        
        if currentScore > bestScore {
            bestScore = currentScore
            bestLabel.text = "Best: " + String(bestScore)
            
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
            UserDefaults.standard.synchronize()
        }
        
        resetCurrentGame()

    }

    
    func resetAlert (title: String, message: String) {
        
        let alert: UIAlertController
        let resetCurrentButton = UIAlertAction(title: "Just Current Game", style: UIAlertActionStyle.default, handler:{ action in
            self.endGame()
        })
        let resetBestButton = UIAlertAction(title: "Best Score", style: UIAlertActionStyle.destructive, handler:{ action in
            self.clearBestScore()
        })

        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(resetCurrentButton)
        alert.addAction(resetBestButton)

        self.present(alert, animated: true, completion: nil)
        
    }
    


}

