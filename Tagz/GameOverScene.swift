//
//  GameOverScene.swift
//  Tagz
//
//  Created by Alberto Dominguez on 12/1/21.
//

import SpriteKit
import GameplayKit

class SKButtonLabel: SKLabelNode {
    var touchupInside: () -> Void = {}
}

class GameOverScene: SKScene {

    // MARK: Properties
    var mainLabel = SKLabelNode()
    var playAgain = SKButtonLabel()
    var exitGame  = SKButtonLabel()
    
    var title: String = ""
    
    
    // MARK: Life Cycles
    override func didMove(to view: SKView) {
        print("GAME OVER")
        
        mainLabel = self.childNode(withName: "mainLabel") as! SKLabelNode
        mainLabel.text = title
        
        setupButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        buttonTap(at: location)
    }
    
    
    // MARK: Button Setup
    
    func setupButtons() {
        playAgain.text = "Play Again"
        playAgain.fontSize = 45
        playAgain.fontName = "Helvetica Neue Light"
        exitGame.text = "Exit Game"
        exitGame.fontSize = 45
        exitGame.fontName = "Helvetica Neue Light"
        
        self.addChild(playAgain)
        self.addChild(exitGame)
        
        playAgain.position = CGPoint(x: 0, y: -150)
        exitGame.position = CGPoint(x: 0, y: -250)
        
        setupButtonActions()
    }
    
    func setupButtonActions() {
        playAgain.touchupInside = {
            let gameOverScene = SKScene(fileNamed: "GameScene")
            gameOverScene?.scaleMode = .aspectFill
            self.view?.presentScene(gameOverScene)
        }
        
        exitGame.touchupInside = {
            print("this leads to home page.")
//            let gameOverScene = SKScene(fileNamed: "GameScene")
//            gameOverScene?.scaleMode = .aspectFill
//            self.view?.presentScene(gameOverScene)
        }
    }
    
    func buttonTap(at location: CGPoint) {
        let node = atPoint(location)
        
        if let button = node as? SKButtonLabel {
            button.touchupInside()
        }
    }

}
