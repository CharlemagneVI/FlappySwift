//
//  Ground.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/6/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class Ground: GKEntity {
    
    init(imageName: String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
        addComponent(GroundComponent())
    }
    
    init(node: SKSpriteNode) {
        super.init()
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.size.width, height: node.frame.size.height))
        node.physicsBody?.isDynamic = false
        node.physicsBody?.collisionBitMask = 1
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        addComponent(GroundComponent())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
