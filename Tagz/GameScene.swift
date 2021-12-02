//
//  GameScene.swift
//  Tagz
//
//  Created by Alberto Dominguez on 11/24/21.
//

import SpriteKit
import GameplayKit
import Darwin


/// objects
///
/// Speed dampener
///     reduces speed of other player for 5 seconds
///
/// speed down
///     speeds up whoever collected it for 5 seconds


class GameScene: SKScene {
    
    // MARK: Properties
    
    // Nodes
    var playerNode = SKSpriteNode()
    var enemyNode = SKSpriteNode()
    
    var peperNode = SKSpriteNode()
    
    var timeLabel = SKLabelNode()
    
    // time intervals
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    
    var timeLeft: Double = 30
    
    // Speed
    var playerSpeed: CGFloat = 1
    var enemySpeed: CGFloat = 0.5
    
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
        playerNode = self.childNode(withName: "player") as! SKSpriteNode
        enemyNode = self.childNode(withName: "enemy") as! SKSpriteNode
        timeLabel = self.childNode(withName: "timeLabel") as! SKLabelNode
        peperNode = self.childNode(withName: "Peper") as! SKSpriteNode
        timeLabel.text = "Time: \(timeLeft) sec"
        
        physicsWorld.contactDelegate = self
        
        configurePhysicsBody()
        setupJoyStick()
    }
    
    override func update(_ currentTime: TimeInterval) {
//        rotateEnemyNodeToFacePlayerNode()
        moveEnemyToPLayer()
        
        timeLeft -= 1/60
        if timeLeft <= 0 {
            presentGameOverScene(withTitle: "You Win")
        }
        timeLabel.text = "Time: \(Int(timeLeft)+1) sec"
        
    }
    
    // MARK: JoyStick Controlls
    func setupJoyStick() {
        addChild(analogJoystick)
        
        // runs when joystick moves
        analogJoystick.on(.move) { [weak self] joystick in
            let pVelocity = joystick.velocity;
            
            guard let self = self else {return}
            
            self.playerNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.playerNode.physicsBody?.applyImpulse(CGVector(dx: pVelocity.x * self.playerSpeed,
                                                                dy: pVelocity.y * self.playerSpeed))
//            self.playerNode.zRotation = joystick.angular
        }
        
        analogJoystick.on(.end) { [weak self] joystick in
            
            guard let self = self else {return}
            
            self.playerNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
    }
}


// MARK: Enemy Mechanics
extension GameScene {
    func rotateEnemyNodeToFacePlayerNode() {
        let dy = playerNode.position.y - enemyNode.position.y
        let dx = playerNode.position.x - enemyNode.position.x
        let angle = atan2(dy, dx) //Trig().cot(rise: dy, run: dx)
        enemyNode.zRotation = angle
    }
    
    func moveEnemyToPLayer() {
        let dx = playerNode.position.x - enemyNode.position.x
        let dy = playerNode.position.y - enemyNode.position.y
        
        enemyNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        // check if peper is near enemy:
        // if so, enemy moves to peper
        // if not, enemy moves to player
        
        if childNode(withName: "Peper") != nil {
            let peperDx = peperNode.position.x - enemyNode.position.x
            let peperDy = peperNode.position.y - enemyNode.position.y
            let peperHyp = sqrt((peperDx * peperDx) + (peperDy * peperDy))
            
            if peperHyp < 200 {
                let enemyImpulse = setEnemyImpulse(dx: peperDx, dy: peperDy)
                enemyNode.physicsBody?.applyImpulse(enemyImpulse)
            } else {
                let enemyImpulse = setEnemyImpulse(dx: dx, dy: dy)
                enemyNode.physicsBody?.applyImpulse(enemyImpulse)
            }
        }
        else {
            let enemyImpulse = setEnemyImpulse(dx: dx, dy: dy)
            enemyNode.physicsBody?.applyImpulse(enemyImpulse)
        }
        
        
    }
    
    
    /// recursive function to set enemy Vector
    func setEnemyImpulse(dx: CGFloat, dy: CGFloat) -> CGVector {
        let dx = dx
        let dy = dy
        let hyp = sqrt((dx * dx) + (dy * dy))
        // hyp should always be 50
        
        let lowerBound: CGFloat = 48 * enemySpeed
        let upperBound: CGFloat = 52 * enemySpeed
        
        
        // BASE CASE: if hyp is within 2 of 100, return
        if lowerBound < hyp && hyp < upperBound {
            return CGVector(dx: dx, dy: dy)
        }
        else if hyp < lowerBound {
            return setEnemyImpulse(dx: dx*1.5, dy: dy*1.5)
        }
        else  {  // if hyp > upperBound
            return setEnemyImpulse(dx: dx/2, dy: dy/2)
        }
        
    }
}


// MARK: Physics Bodies
extension GameScene {
    func configurePhysicsBody() {
        let boarder = SKPhysicsBody(edgeLoopFrom: self.frame)
        boarder.friction = 0
        boarder.restitution = 0
        
        self.physicsBody = boarder
        
        // Setting up edge Physics
        self.physicsBody?.categoryBitMask = PhysicsCatagory.Edge
        self.physicsBody?.collisionBitMask = PhysicsCatagory.Player | PhysicsCatagory.Enemy
        self.physicsBody?.contactTestBitMask = PhysicsCatagory.Player | PhysicsCatagory.Enemy
        
        // set up player physics
        playerNode.physicsBody?.categoryBitMask = PhysicsCatagory.Player
        playerNode.physicsBody?.collisionBitMask = PhysicsCatagory.Enemy | PhysicsCatagory.Edge | PhysicsCatagory.Obstacle
        playerNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy  | PhysicsCatagory.Edge  | PhysicsCatagory.Obstacle
        
        // set up enemy physics
        enemyNode.physicsBody?.categoryBitMask = PhysicsCatagory.Enemy
        enemyNode.physicsBody?.collisionBitMask = PhysicsCatagory.Player | PhysicsCatagory.Edge | PhysicsCatagory.Obstacle
        enemyNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Player | PhysicsCatagory.Edge | PhysicsCatagory.Obstacle
        
        // set up obstacle physics
        enumerateChildNodes(withName: "obstacle") { objectNode, _ in
            objectNode.physicsBody?.categoryBitMask = PhysicsCatagory.Obstacle
            objectNode.physicsBody?.collisionBitMask = PhysicsCatagory.Enemy | PhysicsCatagory.Player
            objectNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy  | PhysicsCatagory.Player
        }
        
        peperNode.physicsBody?.categoryBitMask = PhysicsCatagory.Obstacle
        peperNode.physicsBody?.collisionBitMask = PhysicsCatagory.Player | PhysicsCatagory.Enemy
        peperNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Player | PhysicsCatagory.Enemy
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let playerMask = PhysicsCatagory.Player
        let enemyMask = PhysicsCatagory.Enemy
        let obstacleMask = PhysicsCatagory.Obstacle
        
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        let contactAMAsk = contact.bodyA.categoryBitMask
        let contactBMAsk = contact.bodyB.categoryBitMask
        
        let collision = contactAMAsk | contactBMAsk
        
        switch collision {
        case playerMask | enemyMask:
            print("player & enemy")
            presentGameOverScene(withTitle: "Game Over")
            
        case playerMask | obstacleMask:
            print("player & obstacle")
            
            if nodeA == peperNode || nodeB == peperNode {
                print("player & peper")
                playerSpeed *= 2
                peperNode.removeFromParent()
            }
            
        case enemyMask | obstacleMask:
            print("enemy & obstacle")
            
            if nodeA == peperNode || nodeB == peperNode {
                print("enemy & peper")
                enemySpeed *= 2
                peperNode.removeFromParent()
            }
            
        default:
            break
        }
    }
    
    func presentGameOverScene(withTitle title: String) {
        let gameOverScene = GameOverScene(fileNamed: "GameOver")!
        gameOverScene.title = title
        
        gameOverScene.scaleMode = .aspectFill
        view?.presentScene(gameOverScene)
    }
    
}


// MARK: Physics Model

struct PhysicsCatagory {
    static let None:       UInt32 = 0        // 0000000 0
    static let Player:     UInt32 = 0b1      // 0000001 1
    static let Enemy:      UInt32 = 0b10     // 0000010 2
    static let Obstacle:   UInt32 = 0b100    // 0000100 4
    static let Edge:       UInt32 = 0b1000   // 0001000 8
}

// MARK: ScreenSize
struct ScreenSize {
    static let width  = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

