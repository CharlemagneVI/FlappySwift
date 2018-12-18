//
//  StartButton.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/5/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartButton: SKSpriteNode {
    
    weak var delegate: StartButtonDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.startGame()
    }
}

protocol StartButtonDelegate: class {
    func startGame()
}
