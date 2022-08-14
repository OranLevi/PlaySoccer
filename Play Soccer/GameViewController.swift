//
//  ViewController.swift
//  Play Soccer
//
//  Created by Oran on 16/07/2022.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var centerView: UIView!
    
    static let shared: GameViewController = GameViewController()
    
    var audioPlayer : AVAudioPlayer!
    var goals = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalsLabel?.text = "0"
        timerLabel?.text = "20"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
        startGame()
    }
    
    //MARK: - start Game
    
    func startGame(){
        for _ in 1...25 {
            let randomY = Int.random(in: 310..<Int(view.bounds.height))
            let randomX = Int.random(in: 20..<270)
            let myView = Ball(frame: CGRect(x: randomX, y: randomY, width: 60, height: 60))
            self.view.addSubview(myView)
            let action: Selector? = #selector(GameViewController.draggedView(_:))
            let panGestureRecoginzer = UIPanGestureRecognizer(target: self, action: action)
            myView.addGestureRecognizer(panGestureRecoginzer)
        }
    }
    
    //MARK: - draggedView
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        guard let draggedView = sender.view else { return }
        draggedView.center = sender.location(in: self.view)
        self.view.bringSubviewToFront(draggedView)
        if sender.state == .ended {
            if centerView.frame.contains(draggedView.center){
                UIView.animate(withDuration: 1 ) {
                    draggedView.alpha = 0
                    self.goals += 1
                    self.goalsLabel.text = String(self.goals)
                    self.playSound()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    draggedView.removeFromSuperview()
                }
            }
        }
    }
    
    //MARK: - Timer and GameOver
    
    func startTimer(){
        var timeLeft = 20
        Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timeLeft -= 1
            self.timerLabel?.text = String(timeLeft)
            if(timeLeft==0) || (self.goals == 20){
                timer.invalidate()
                let dialogMessage = UIAlertController(title: "The Game is Over", message: "Your result: \n Goals: \(self.goals)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Start Again", style: .default, handler: { (action) -> Void in
                    self.view.subviews.forEach({ $0.removeFromSuperview() })
                    self.loadView()
                    self.startGame()
                    self.startTimer()
                    self.goals = 0
                    self.goalsLabel?.text = "0"
                    self.timerLabel?.text = "20"
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Sound
    func playSound() {
        let coinSound = URL(fileURLWithPath: Bundle.main.path(forResource: "goal-sound", ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:coinSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch {
            print("Error getting the audio file")
        }
    }
}

//MARK: - Class Ball

class Ball: UIView {
    override func draw(_ rect: CGRect) {
        let image = UIImage(named: "Ball.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: 60,
                                 height: 60)
        self.addSubview(imageView)
    }
}
