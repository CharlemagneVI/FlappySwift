//
//  Background.swift
//  FlappySwift
//
//  Created by Chad Fager on 12/18/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class Background: SKSpriteNode {
    
    let backgroundDay: String = "BackgroundDay"
    let backgroundNight: String = "BackgroundNight"
    
    func randomizeBackground() {
        let rand = Int.random(in: 1 ... 2)
        
        switch rand {
        case 1:
            self.texture = SKTexture(imageNamed: backgroundDay)
        case 2:
            self.texture = SKTexture(imageNamed: backgroundNight)
        default:
            self.texture = SKTexture(imageNamed: backgroundDay)
        }
        
        self.texture?.filteringMode = .nearest
    }
}
