//
//  PauseViewController.swift
//  Space
//
//  Created by Artur Kamaldinov on 4/17/21.
//

import UIKit

protocol PauseVCDelegate {
    func pauseViewControllerPlayButton(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {
    
    var delegate: PauseVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func playButton(_ sender: UIButton) {
        delegate.pauseViewControllerPlayButton(self)
        //                    pauseController.willMove(toParent: nil)
        //                    pauseController.removeFromParent()
        //                    pauseController.view.removeFromSuperview()
        //                    gameScene.gameIsPaused = false
    }
    
    @IBAction func buyButton(_ sender: Any) {
    }
}

