//
//  SpriteComponent.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/5/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    public let node: SKSpriteNode
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
    }
    
    init(spriteNode: SKSpriteNode) {
        node = spriteNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
