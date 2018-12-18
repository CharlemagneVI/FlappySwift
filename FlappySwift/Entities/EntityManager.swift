//
//  EntityManager.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/5/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    let scene: SKScene
    
    //Seconds each pipe spawns, and the delta between the last one spawned
    private var pipeDelay: TimeInterval = 1.8
    private var pipeDelayDelta: TimeInterval = 0
    
    //Use these for setting pipe locations and distance between the pipes
    private var pipeUpUpperBound: Double = 741
    private var pipeUpLowerBound: Double = 347
    private var pipeDistance: Double = 200.0//266.0
    private var pipeXSpawn: Double = 427.0
    
    public var spawnOn: Bool = false
    
    public var currentPipeColor: PipeColor = .green
    
    //Declare the names for the resources to be used
    private var greenPipeResourceNames = ["PipeDownGreen", "PipeUpGreen"]
    private var redPipeResourceNames = ["PipeDownRed", "PipeUpRed"]
    
    init(scene: SKScene) {
        self.scene = scene
    }

    func update(_ deltaTime: CFTimeInterval) {
        for entity in entities {
            entity.update(deltaTime: deltaTime)
        }
        
        if(spawnOn) {
            if(pipeDelayDelta >= 0) {
                pipeDelayDelta -= deltaTime
            } else {
                spawnPipeSet()
            }
        }
    }
    
    //For programatically created entities
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    //For entities that were added in the scene GUI
    func addExistingEntityToManager(_ entity: GKEntity) {
        entities.insert(entity)
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
    }
    
    func randomizePipeColor() {
        let rand = Int.random(in: 1 ... 2)
        
        switch rand {
        case 1:
            currentPipeColor = .green
        case 2:
            currentPipeColor = .red
        default:
            currentPipeColor = .green
        }
    }
    
    func spawnPipeSet() {
        pipeDelayDelta = pipeDelay //Reset the pipe spawn delta to how log it should wait to spawn the next set
        
        var pipeDownNode: Pipe!
        var pipeUpNode: Pipe!
        var pipeGoal: PipeGoal!
        
        if(currentPipeColor == .green) {
            pipeDownNode = Pipe(imageName: greenPipeResourceNames[0])
            pipeUpNode = Pipe(imageName: greenPipeResourceNames[1])
        } else {
            pipeDownNode = Pipe(imageName: redPipeResourceNames[0])
            pipeUpNode = Pipe(imageName: redPipeResourceNames[1])
        }
        
        pipeGoal = PipeGoal(rectOf: CGSize(width: Double(pipeUpNode.frame.width / 4), height: pipeDistance))
        pipeGoal.setupPhysicsBody()
        
        let upperPipeY = Double.random(in: pipeUpLowerBound ... pipeUpUpperBound)
        let lowerPipeY = (upperPipeY - pipeDistance) - Double(pipeUpNode.size.height)
        
        pipeDownNode.position = CGPoint(x: pipeXSpawn, y: upperPipeY)
        pipeUpNode.position = CGPoint(x: pipeXSpawn, y: lowerPipeY)
        pipeGoal.position = CGPoint(x: pipeXSpawn, y: upperPipeY - pipeDistance * 2)
        
        scene.addChild(pipeDownNode)
        scene.addChild(pipeUpNode)
        scene.addChild(pipeGoal)
        
        if let moveAction = SKAction(named: "MovePipe") {
            pipeDownNode.run(moveAction, completion: {
                pipeDownNode.removeFromParent()
            })
            pipeUpNode.run(moveAction, completion: {
                pipeUpNode.removeFromParent()
            })
            pipeGoal.run(moveAction, completion: {
                pipeGoal.removeFromParent()
            })
        }
    }
}
