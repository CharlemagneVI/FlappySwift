//
//  RestartButton.swift
//  FlappySwift
//
//  Created by Chad Fager on 12/18/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class RestartButton: SKSpriteNode {
    
    weak var delegate: RestartButtonDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.restartGame()
    }
}

protocol RestartButtonDelegate: class {
    func restartGame()
}
