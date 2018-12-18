//
//  ScoreCard.swift
//  FlappySwift
//
//  Created by Chad Fager on 12/14/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class ScoreCard: SKSpriteNode {
    var currentScoreLabel: SKLabelNode!
    var currentScoreLabelBG: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    var bestScoreLabelBG: SKLabelNode!
    var medalNode: SKSpriteNode!
    var newHighScoreNode: SKSpriteNode!
    var okButton: RestartButton!
    
    var highestScore: Int!
    var bronzeMedalThreshold: Int = 10
    var silverMedalThreshold: Int = 25
    var goldMedalThreshold: Int = 50
    var platinumMedalThreshold: Int = 100
    
    func setup() {
        currentScoreLabel = self.childNode(withName: "SCCurrentScoreLabel") as? SKLabelNode
        currentScoreLabelBG = self.childNode(withName: "SCCurrentScoreLabelBG") as? SKLabelNode
        bestScoreLabel = self.childNode(withName: "SCBestScoreLabel") as? SKLabelNode
        bestScoreLabelBG = self.childNode(withName: "SCBestScoreLabelBG") as? SKLabelNode
        medalNode = self.childNode(withName: "SCMedal") as? SKSpriteNode
        newHighScoreNode = self.childNode(withName: "NewHighScoreNode") as? SKSpriteNode
        okButton = self.childNode(withName: "OkButton") as? RestartButton
        
        if let score = UserDefaults.standard.object(forKey: "HighestScore") as? Int {
            highestScore = score
            bestScoreLabel.text = String(highestScore)
            bestScoreLabelBG.text = String(highestScore)
        } else {
            highestScore = 0
        }
        
        okButton.texture?.filteringMode = .nearest
        newHighScoreNode.texture?.filteringMode = .nearest
        newHighScoreNode.alpha = 0.0
        
        okButton.isUserInteractionEnabled = true
    }
    
    func updateScores(score: Int) {
        if(score > highestScore) {
            highestScore = score
            UserDefaults.standard.set(score, forKey: "HighestScore")
            UserDefaults.standard.synchronize()
            bestScoreLabel.text = String(highestScore)
            bestScoreLabelBG.text = String(highestScore)
            newHighScoreNode.alpha = 1.0
        }
        
        currentScoreLabel.text = String(score)
        currentScoreLabelBG.text = String(score)
        
        switch score {
        case bronzeMedalThreshold..<silverMedalThreshold:
            medalNode.texture = SKTexture(imageNamed: "BronzeMedal")
            medalNode.texture?.filteringMode = .nearest
        case silverMedalThreshold..<goldMedalThreshold:
            medalNode.texture = SKTexture(imageNamed: "SilverMedal")
            medalNode.texture?.filteringMode = .nearest
        case goldMedalThreshold..<platinumMedalThreshold:
            medalNode.texture = SKTexture(imageNamed: "GoldMedal")
            medalNode.texture?.filteringMode = .nearest
        case platinumMedalThreshold...:
            medalNode.texture = SKTexture(imageNamed: "PlatinumMedal")
            medalNode.texture?.filteringMode = .nearest
        default:
            medalNode.texture = nil
            medalNode.color = UIColor.clear
        }
    }
}
