//
//  GameScene.swift
//  Tagz
//
//  Created by Alberto Dominguez on 11/24/21.
//

import SpriteKit
import GameplayKit
import Darwin


class GameScene: SKScene {
    
    // MARK: Properties
    
    // Nodes
    var playerNode = SKShapeNode()
    var enemyNode = SKShapeNode()
    
    // Speed
    var playerSpeed = CGFloat(0.05)
    var enemySpeed = CGFloat(0.04)
    
    // joystick controller
    var analogJoystick: TLAnalogJoystick = {
        let base = TLAnalogJoystickComponent(diameter: 200, color: nil, image: UIImage(named: "jSubstrate"))
        let handle = TLAnalogJoystickComponent(diameter: 100, color: nil, image: UIImage(named: "jStick"))
        let js = TLAnalogJoystick(withBase: base, handle: handle)
        
        js.position = CGPoint(x: 150, y: 150)
        js.zPosition = 10
        
        return js
    }()
    
    // MARK: Life Cycle
    override func didMove(to view: SKView) {
        playerNode = self.childNode(withName: "player") as! SKShapeNode
        enemyNode = self.childNode(withName: "enemy") as! SKShapeNode
        
        setupJoyStick()
    }
    
    override func update(_ currentTime: TimeInterval) {
        rotateEnemyNodeToFacePlayerNode()
        moveEnemyToPLayer()
    }
    
    // MARK: Helpers
    func setupJoyStick() {
        addChild(analogJoystick)
        
        // runs when joystick moves
        analogJoystick.on(.move) { [unowned self] joystick in
            let pVelocity = joystick.velocity;
            let speed = playerSpeed
            
            playerNode.position = CGPoint(x: playerNode.position.x + (pVelocity.x * speed),
                                          y: playerNode.position.y + (pVelocity.y * speed))
            playerNode.zRotation = joystick.angular
        }
    }
    
    func rotateEnemyNodeToFacePlayerNode() {
        let dy = playerNode.position.y - enemyNode.position.y
        let dx = playerNode.position.x - enemyNode.position.x
        let angle = Trig().cot(rise: dy, run: dx)
        enemyNode.zRotation = angle
    }
    
    func moveEnemyToPLayer() {
        let dx = playerNode.position.x - enemyNode.position.x
        let dy = playerNode.position.y  - enemyNode.position.y
        
        let enemySpeed = sqrt((dx * dx) + (dy * dy))
        
        // TODO: not using enemySpeed set from Properties. Will make it hard to adjust enemy speed when choosing difficulty.
        enemyNode.position = CGPoint(x: enemyNode.position.x + (dx/enemySpeed),
                                     y: enemyNode.position.y + (dy/enemySpeed))
    }
    
    
    
}







struct ScreenSize {
    static let width  = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}


struct Trig {
    /*
    sin(Θ) = rise/hyp
    cos(Θ) = run /hyp
    tan(Θ) = rise/run
    
    csc(rise/hyp) = Θ
    sec(run/hyp)  = Θ
    cot(rise/hyp) = Θ
    */
    
    /// finds angle Θ based on rise and run
    /// angle = cot(rise: playerVelocity.dy, run: playerVelocity.dx)
    func cot(rise: CGFloat, run: CGFloat) -> CGFloat {
        return atan2(rise, run)
    }
}
