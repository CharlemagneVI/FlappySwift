//
//  GroundComponent.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/6/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class GroundComponent: GKComponent {
    
    var shouldMove = true
    
    var moveTimeInterval: TimeInterval = 0.02
    var moveTimeDelta: TimeInterval = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
       moveGround()
    }
    
    func moveGround() {
        let moveAction = SKAction(named: "MoveGround")
        if let entity = entity, let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.run(moveAction!, completion: {
                if(spriteComponent.node.position.x.rounded() <= -750) {
                    spriteComponent.node.position.x = 750
                    self.moveGround()
                } else {
                    self.moveGround()
                }
            })
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
//        guard let entity = entity,
//            let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
//            return
//        }
        
        //moveTimeDelta -= seconds
        
//        //This needs to be fixed as well since its frame based currently.
//        if(shouldMove && moveTimeDelta <= 0) {
//            spriteComponent.node.position.x -= 10.0 // For whatever reason this value gains precision eventually and has to be rounded.
//            //spriteComponent.node.position.x = round(spriteComponent.node.position.x)
//            moveTimeDelta = moveTimeInterval
//            if(spriteComponent.node.position.x.rounded() <= -750) {
//                spriteComponent.node.position.x = 750
//            }
//        }
    }
}
