//
//  Player.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/5/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    var alive = true
    
    enum BirdColor {
        case red
        case yellow
        case blue
    }
    
    var birdColor: BirdColor!
    
    init(imageName: String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
    }
    
    init(node: SKSpriteNode) {
        super.init()
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.height / 2)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.collisionBitMask = 2
        node.physicsBody?.contactTestBitMask = 1
        
        let flapAction = SKAction(named: "RedBirdFlap")
        node.run(flapAction!)
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        birdColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if let spriteComponent = component(ofType: SpriteComponent.self) {
            //do animation in here?
            spriteComponent.node.texture?.filteringMode = .nearest
            if let physicsBody = spriteComponent.node.physicsBody {
                spriteComponent.node.zRotation = clamp(min: -1, max: 0.5, value: physicsBody.velocity.dy * (physicsBody.velocity.dy < 0 ? 0.003 : 0.001))
            }
        }
    }
    
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if(value > max) {
            return max
        } else if (value < min) {
            return min
        } else {
            return value
        }
    }
    
    func stopAnimation() {
        guard let spriteComponent = component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.isPaused = true
    }
    
    //Change the skin of the bird based on a randomly generated number
    func changeSkin() {
        let rand = Int.random(in: 1 ... 3)
        
        guard let spriteComponent = component(ofType: SpriteComponent.self) else {
            return
        }
        
        switch rand {
        case 1:
            spriteComponent.node.texture = SKTexture(imageNamed: "BirdRedNeutral")
            if let flapAction = SKAction(named: "RedBirdFlap") {
                spriteComponent.node.run(flapAction)
            }
            birdColor = .red
        case 2:
            spriteComponent.node.texture = SKTexture(imageNamed: "BirdBlueNeutral")
            if let flapAction = SKAction(named: "BlueBirdFlap") {
                spriteComponent.node.run(flapAction)
            }
            birdColor = .blue
        case 3:
            spriteComponent.node.texture = SKTexture(imageNamed: "BirdYellowNeutral")
            if let flapAction = SKAction(named: "YellowBirdFlap") {
                spriteComponent.node.run(flapAction)
            }
            birdColor = .yellow
        default:
            spriteComponent.node.texture = SKTexture(imageNamed: "BirdRedNeutral")
            if let flapAction = SKAction(named: "RedBirdFlap") {
                 spriteComponent.node.run(flapAction)
            }
            birdColor = .red
        }
    }
    
    //Make the player flap
    func flap() {
        if let spriteComponent = component(ofType: SpriteComponent.self) {
            spriteComponent.node.physicsBody?.velocity = CGVector(dx: 0, dy: 0) //Reset the velocity every touch to stop accumulation
            spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
    }
}
