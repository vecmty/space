//
//  GameScene.swift
//  Space
//
//  Created by Artur Kamaldinov on 4/9/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let spaceShipCategory: UInt32 = 0x1 << 0
    let asteroidCategory: UInt32 = 0x1 << 1
    
    
    // создание node ship
    var spaceShip: SKSpriteNode!
    var score = 0
    var scoreLabel: SKLabelNode!
    var spaceBackground: SKSpriteNode!
    var asteroidLayer: SKNode!
    var starsLayer: SKNode!
    var spaceShipLayer: SKNode!
    
    
    var gameIsPaused: Bool = false
    
    func pauseButton(sender: AnyObject) {
        if !gameIsPaused {
            pauseTheGame()
        } else {
            unpauseTheGame()
        }
    }
    
    func pauseTheGame() {
        gameIsPaused = true
        self.asteroidLayer.isPaused = true
        physicsWorld.speed = 0
        starsLayer.isPaused = true
    }
    func unpauseTheGame() {
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        starsLayer.isPaused = false
    }
    
    func resetTheGame() {
        score = 0
        scoreLabel.text = "Score: \(score)"
        
        unpauseTheGame()
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        //        scene?.size = UIScreen.main.bounds.size
        
        // background init
        spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        //        spaceBackground.size = self.frame.size
        spaceBackground.size = CGSize(width: self.frame.width + 100, height: self.frame.height + 100)
        spaceBackground.zPosition = -1
        addChild(spaceBackground)
        
        
        let startsEmitter = SKEmitterNode(fileNamed: "Stars.sks")
        startsEmitter?.zPosition = 0
        startsEmitter?.position = CGPoint(x: frame.midX, y: frame.height / 2)
        startsEmitter?.particlePositionRange.dx = frame.width
        startsEmitter?.advanceSimulationTime(10)
        
        starsLayer = SKNode()
        addChild(starsLayer)
        starsLayer.addChild(startsEmitter!)
        
        // node init
        spaceShip = SKSpriteNode(imageNamed: "ship")
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
        
        //        let colorAction1 = SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 1)
        //        let colorAction2 = SKAction.colorize(with: .white, colorBlendFactor: 0, duration: 1)
        //        let colorSequenceAnimation = SKAction.sequence([colorAction1, colorAction2])
        //        let colorActionRepeat = SKAction.repeatForever(colorSequenceAnimation)
        //
        //        spaceShip.run(colorActionRepeat)
        
        //        addChild(spaceShip)
        spaceShipLayer = SKNode()
        spaceShipLayer.addChild(spaceShip)
        spaceShipLayer.zPosition = 3
        spaceShip.zPosition = 1
        //        spaceShipLayer.position = CGPoint(x: frame.midX, y: frame.height / 5)
        addChild(spaceShipLayer)
        
        let fireEmitter = SKEmitterNode(fileNamed: "Fire.sks")
        fireEmitter?.zPosition = 0
        fireEmitter?.position.y = -40
        //        fireEmitter?.targetNode = self
        spaceShipLayer.addChild(fireEmitter!)
        
        
        //generation asteroid
        asteroidLayer = SKNode()
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)
        
        
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            //            self.addChild(asteroid)
            if asteroid.physicsBody != nil {
                self.asteroidLayer.addChild(asteroid)
                asteroid.zPosition = 2
            }
        }
        let asteroidPerSecond: Double = 1
        let asteroidCreationDelay = SKAction.wait(forDuration: 1 / asteroidPerSecond, withRange: 1)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate,asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        self.asteroidLayer.run(asteroidRunAction)
        
        scoreLabel = SKLabelNode(text: "Score \(score)")
        scoreLabel.position = CGPoint(x: frame.size.width / scoreLabel.frame.size.width, y: 500)
        scoreLabel.fontSize = 40
        scoreLabel.fontName = "AvenirNext-Bold"
        
        
        
        //frame.size.height - scoreLabel.calculateAccumulatedFrame().height)
        addChild(scoreLabel)
        
        scoreLabel.zPosition = 3
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameIsPaused {
            
            if let touch = touches.first {
                // точка  тыка
                let touchLocation =  touch.location(in: self)
                //            print(touchLocation)
                
                //            let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
                //            let speed: CGFloat = 500
                //            let time = timetoTravel(distance: distance, speed: speed)
                
                
                let moveAction = SKAction.move(to: touchLocation, duration: 1)
                
                //            print(distance,speed)
                spaceShipLayer.run(moveAction)
                
                let bgMoveAction = SKAction.move(to: CGPoint(x: -touchLocation.x / 20, y: -touchLocation.y / 20), duration: 1)
                
                spaceBackground.run(bgMoveAction)
                
            }
            
        }
    }
    
    //    func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
    //        return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) + (b.y - a.y))
    //    }
    //    func timetoTravel(distance: CGFloat, speed: CGFloat) -> TimeInterval {
    //        let time = distance / speed
    //        return TimeInterval(time)
    //    }
    
    
    func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "cow")
        
        let randomScale = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6)) / 3
        asteroid.xScale = randomScale
        asteroid.yScale = randomScale
        
        asteroid.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 1))
        asteroid.position.y = frame.size.height + asteroid.size.height
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        
        asteroid.name = "asteroid"
        
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory | asteroidCategory
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
        
        let asteroidSpeedX: CGFloat = 100.0
        asteroid.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 5
        asteroid.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeedX
        
        return asteroid
    }
    
    //    override func update(_ currentTime: TimeInterval) {
    //        let asteroid = createAsteroid()
    //        addChild(asteroid)
    //    }
    
    
    override func didSimulatePhysics() {
        asteroidLayer.enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            let hight = UIScreen.main.bounds.height
            if asteroid.position.y < -hight {
                asteroid.removeFromParent()
                
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == spaceShipCategory && contact.bodyB.categoryBitMask == asteroidCategory || contact.bodyB.categoryBitMask == spaceShipCategory && contact.bodyA.categoryBitMask == asteroidCategory {
            self.score = 0
            self.scoreLabel.text = "Score: \(score)"
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
