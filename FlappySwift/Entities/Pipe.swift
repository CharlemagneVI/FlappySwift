//
//  Pipe.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/5/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class Pipe: SKSpriteNode {
    
    convenience init(imageName: String) {
        self.init(imageNamed: imageName)
        
        name = "Pipe"
        scale(to: CGSize(width: size.width * 5, height: size.height * 5))
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height))
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        //physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 0
        //physicsBody?.contactTestBitMask = 1
        zPosition = 3
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        texture.filteringMode = .nearest
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
