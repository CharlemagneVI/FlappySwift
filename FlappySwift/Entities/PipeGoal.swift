//
//  PipeGoal.swift
//  FlappySwift
//
//  Created by Chad Fager on 12/13/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import GameplayKit
import SpriteKit

class PipeGoal: SKShapeNode {
    
    override init() {
        super.init()
        
        zPosition = 3
        name = "Goal"
        fillColor = UIColor.clear
        lineWidth = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.size.width, height: frame.size.height))
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.collisionBitMask = 2
        physicsBody?.categoryBitMask = 1
    }
}
