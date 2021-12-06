//
//  HomeScene.swift
//  Tagz
//
//  Created by Alberto Dominguez on 12/6/21.
//

import SpriteKit
import GameKit

class HomeScene: SKScene {
    
    // MARK: - Properties
    
    // Dificulty Labels
    var easyDifficulty = SKButtonLabel()
    var mediumDificulty  = SKButtonLabel()
    var hardDificulty = SKButtonLabel()
    
    // Time Labels
    var shortGame = SKButtonLabel()
    var mediumGame  = SKButtonLabel()
    var longGame = SKButtonLabel()
    
    // Start
    var startGame = SKButtonLabel()
    
    // Game Settings
    var gameSettings = GameSettings(difficulty: .medium, time: .medium)
    
    
    
    // MARK: - Life Cycle
    
    override func didMove(to view: SKView) {
        print("On home page")
        setupButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        buttonTap(at: location)
    }
    
    
    // MARK: - Set up UI
    
    func setupButtons() {
        
        // set up button styles
        unselected(easyDifficulty, text: "Easy")
        selected(mediumDificulty, text: "Medium")
        unselected(hardDificulty, text: "Hard")
        
        unselected(shortGame, text: "Short")
        selected(mediumGame, text: "Medium")
        unselected(longGame, text: "Long")
        
        startGame.text = "Start Game"
        startGame.fontSize = 60
        startGame.fontName = "Helvetica Neue Light"
        
        // Adding to parent
        self.addChild(easyDifficulty)
        self.addChild(mediumDificulty)
        self.addChild(hardDificulty)
        
        self.addChild(shortGame)
        self.addChild(mediumGame)
        self.addChild(longGame)
        
        self.addChild(startGame)
        
        // Positioning
        easyDifficulty.position    = CGPoint(x: -200, y: 0)
        (mediumDificulty).position = CGPoint(x:    0, y: 0)
        hardDificulty.position     = CGPoint(x:  200, y: 0)
        
        shortGame.position         = CGPoint(x: -200, y: -150)
        mediumGame.position        = CGPoint(x:    0, y: -150)
        longGame.position          = CGPoint(x:  200, y: -150)
        
        startGame.position         = CGPoint(x:    0, y: -400)
        
        setupButtonActions()
    }
    
    func unselected(_ button: SKButtonLabel, text: String) {
        button.text = text
        button.fontSize = 45
        button.fontName = "Helvetica Neue Light"
    }
    
    func selected(_ button: SKButtonLabel, text: String) {
        button.text = text
        button.fontSize = 45
        button.fontName = "Helvetica Neue Bold"
    }
    
    
    // MARK: - Button Actions
    func setupButtonActions() {
        easyDifficulty.touchupInside = { [self] in
            print("Easy DIfficulty was selected")
            selected(easyDifficulty, text: "Easy")
            unselected(mediumDificulty, text: "Medium")
            unselected(hardDificulty, text: "Hard")
            gameSettings.difficulty = Difficulty.easy
            print(gameSettings)
        }
        
        mediumDificulty.touchupInside = { [self] in
            print("Medium DIfficulty was selected")
            unselected(easyDifficulty, text: "Easy")
            selected(mediumDificulty, text: "Medium")
            unselected(hardDificulty, text: "Hard")
            gameSettings.difficulty = Difficulty.medium
            print(gameSettings)
        }
        
        hardDificulty.touchupInside = { [self] in
            print("Hard DIfficulty was selected")
            unselected(easyDifficulty, text: "Easy")
            unselected(mediumDificulty, text: "Medium")
            selected(hardDificulty, text: "Hard")
            gameSettings.difficulty = Difficulty.hard
            print(gameSettings)
        }
        
        shortGame.touchupInside = { [self] in
            print("Short game was selected")
            selected(shortGame, text: "Short")
            unselected(mediumGame, text: "Medium")
            unselected(longGame, text: "Long")
            gameSettings.time = GameDurration.short
            print(gameSettings)
        }
        
        mediumGame.touchupInside = { [self] in
            print("Medium game was selected")
            unselected(shortGame, text: "Short")
            selected(mediumGame, text: "Medium")
            unselected(longGame, text: "Long")
            gameSettings.time = GameDurration.medium
            print(gameSettings)
        }
        
        longGame.touchupInside = { [self] in
            print("Long game was selected")
            unselected(shortGame, text: "Short")
            unselected(mediumGame, text: "Medium")
            selected(longGame, text: "Long")
            gameSettings.time = GameDurration.long
            print(gameSettings)
        }
        
        startGame.touchupInside = { [self] in
            print("Start new Game")
            print(gameSettings)
            
            let gameScene = GameScene(fileNamed: "GameScene")! 
            gameScene.scaleMode = .aspectFill
            gameScene.timeLeft = gameSettings.time.rawValue
            gameScene.enemySpeed = gameSettings.difficulty.rawValue
            
            self.view?.presentScene(gameScene)
        }
        
        
    }
    
    func buttonTap(at location: CGPoint) {
        let node = atPoint(location)
        
        if let button = node as? SKButtonLabel {
            button.touchupInside()
        }
    }
    
    
    
}

// MARK: Game Settings Models
struct GameSettings {
    var difficulty: Difficulty
    var time: GameDurration
}

enum Difficulty: CGFloat {
    case easy = 0.2
    case medium = 0.4
    case hard = 0.6
}

enum GameDurration: Double {
    case short = 15
    case medium = 30
    case long = 60
}
