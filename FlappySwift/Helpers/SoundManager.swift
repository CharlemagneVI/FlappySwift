//
//  SoundManager.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/5/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import Foundation
import SpriteKit

class SoundManager {
    let soundFlap = SKAction.playSoundFileNamed("sfx_wing.wav", waitForCompletion: false)
    let soundPoint = SKAction.playSoundFileNamed("sfx_point.wav", waitForCompletion: false)
    let soundDie = SKAction.playSoundFileNamed("sfx_die.wav", waitForCompletion: false)
    let soundHit = SKAction.playSoundFileNamed("sfx_hit.wav", waitForCompletion: false)
    let soundSwoosh = SKAction.playSoundFileNamed("sfx_swooshing.wav", waitForCompletion: false)
    
    static let sharedInstance = SoundManager()
}
