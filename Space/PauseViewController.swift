//
//  PauseViewController.swift
//  Space
//
//  Created by Artur Kamaldinov on 4/17/21.
//

import UIKit

//protocol PauseVCDelegate {
//    func pauseVCPlayButton(_ viewController: PauseViewController) {
//    }

class PauseViewController: UIViewController {
    
//    //    var delegate: PauseVCDelegate!
//    var gameScene: GameScene
//    var gameVC: GameViewController
//    var pauseController: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func playButton(_ sender: UIButton) {
        //        delegate.pauseVCPlayButton(self)
//        pauseController.willMove(toParent: nil)
//        pauseController.removeFromParent()
//        pauseController.view.removeFromSuperview()
//        gameScene.gameIsPaused = false
    }
    
    @IBAction func buyButton(_ sender: Any) {
    }
}

