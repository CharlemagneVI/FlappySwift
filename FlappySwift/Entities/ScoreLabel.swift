//
//  ScoreLabel.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/11/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ScoreLabel {
    var label: SKLabelNode
    var backgroundNode: SKLabelNode //The background label node that creates the "shadow"
    
    var score: Int!
    
    init(mainLabel: SKLabelNode, backgroundLabel: SKLabelNode) {
        label = mainLabel
        backgroundNode = backgroundLabel
        score = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run(_ action: SKAction) {
        label.run(action)
        backgroundNode.run(action)
    }
    
    func incrementScore() {
        score += 1
        
        label.text = String(score)
        backgroundNode.text = String(score)
    }
}
