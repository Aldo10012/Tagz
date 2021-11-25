//
//  GameScene.swift
//  Tagz
//
//  Created by Alberto Dominguez on 11/24/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: Properties
    // Nodes
    var playerNode = SKShapeNode()
    var player = SKSpriteNode()
    
    // Speed
    var nodeSpeed = CGFloat(0.05)
    
    var analogJoystick: TLAnalogJoystick = {
        let base = TLAnalogJoystickComponent(diameter: 200, color: nil, image: UIImage(named: "jSubstrate"))
        let handle = TLAnalogJoystickComponent(diameter: 100, color: nil, image: UIImage(named: "jStick"))
        let js = TLAnalogJoystick(withBase: base, handle: handle)
        
        js.position = CGPoint(x: 150, y: 150)
        js.zPosition = 10
        
        return js
    }()
    
    override func didMove(to view: SKView) {
        playerNode = self.childNode(withName: "player") as! SKShapeNode
        
        setupJoyStick()
    }
    
    // MARK: Helpers
    func setupJoyStick() {
        addChild(analogJoystick)
        
        // runs when joystick moves
        analogJoystick.on(.move) { [unowned self] joystick in
            let pVelocity = joystick.velocity;
            let speed = nodeSpeed
            
            playerNode.position = CGPoint(x: playerNode.position.x + (pVelocity.x * speed), y: playerNode.position.y + (pVelocity.y * speed))
            playerNode.zRotation = joystick.angular
        }
    }
    
}






struct ScreenSize {
    static let width  = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}
