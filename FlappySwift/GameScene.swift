//
//  GameScene.swift
//  FlappyBird
//
//  Created by Chad Fager on 12/4/18.
//  Copyright © 2018 Norfare. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PipeColor {
    case red
    case green
}

class GameScene: SKScene, StartButtonDelegate, RestartButtonDelegate, SKPhysicsContactDelegate {
    
    var player: Player!
    var background: Background!
    var mainLogo: SKSpriteNode!
    var startButton: StartButton!
    var instructions: SKSpriteNode!
    var getReadyLabel: SKSpriteNode!
    var scoreLabel: ScoreLabel!
    var gameOverLabel: SKSpriteNode!
    var scoreCard: ScoreCard!
    
    var entityManager: EntityManager!
    
    //Update time
    private var lastUpdateTime : TimeInterval = 0
    
    //The delay for the start of the game, and the delta time passed
    private var startUpDelay: TimeInterval = 3.0
    private var startUpDelta: TimeInterval = 0
    
    //Determine whether the game is in play or not
    private var playing = false
    
    //score of the current game
    var score: Int = 0
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        background = self.childNode(withName: "Background") as? Background
        startButton = self.childNode(withName: "TitlePlayButton") as? StartButton
        instructions = self.childNode(withName: "Instructions") as? SKSpriteNode
        mainLogo = self.childNode(withName: "TitleLogo") as? SKSpriteNode
        getReadyLabel = self.childNode(withName: "GetReadyLabel") as? SKSpriteNode
        scoreLabel = ScoreLabel(mainLabel: self.childNode(withName: "ScoreLabel") as! SKLabelNode, backgroundLabel: self.childNode(withName: "ScoreLabelBG") as! SKLabelNode)
        gameOverLabel = self.childNode(withName: "GameOverLabel") as? SKSpriteNode
        scoreCard = self.childNode(withName: "ScoreCard") as? ScoreCard
        
        background.randomizeBackground()
        scoreCard.setup()
        
        scoreCard.okButton.delegate = self
        startButton.delegate = self
        
        mainLogo.texture?.filteringMode = .nearest
        startButton.texture?.filteringMode = .nearest
        getReadyLabel.texture?.filteringMode = .nearest
        instructions.texture?.filteringMode = .nearest
        gameOverLabel.texture?.filteringMode = .nearest
        scoreCard.texture?.filteringMode = .nearest
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.5)
        self.physicsWorld.speed = 0.0
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        entityManager = EntityManager(scene: self)
        
        if let playerNode = self.childNode(withName: "Player") as? SKSpriteNode {
            playerNode.texture?.filteringMode = .nearest
            player = Player(node: playerNode)
            player.setConstraints(width: size.width, height: size.height)
            player.changeSkin()
            entityManager.addExistingEntityToManager(player)
        }
        
        if let groundOneNode = self.childNode(withName: "GroundOne") as? SKSpriteNode {
            groundOneNode.texture?.filteringMode = .nearest
            let groundOne = Ground(node: groundOneNode)
            entityManager.addExistingEntityToManager(groundOne)
        }
        
        if let groundTwoNode = self.childNode(withName: "GroundTwo") as? SKSpriteNode {
            groundTwoNode.texture?.filteringMode = .nearest
            let groundTwo = Ground(node: groundTwoNode)
            entityManager.addExistingEntityToManager(groundTwo)
        }
        
        startButton.isUserInteractionEnabled = true
        entityManager.randomizePipeColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if(playing) {
            scene?.run(SoundManager.sharedInstance.soundFlap)
            player.flap()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
       
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        entityManager.update(dt)
        
        //If the play state has changed, show the tutorial, then begin spawning pipes
        if(playing && startUpDelta >= 0 && !entityManager.spawnOn) {
            startUpDelta -= dt
        } else if (playing && startUpDelta <= 0 && !entityManager.spawnOn) {
            entityManager.spawnOn = true
            
            let fadeOutElements = SKAction.fadeOut(withDuration: 0.5)
            let fadeInElements = SKAction.fadeIn(withDuration: 0.5)
            
            instructions.run(fadeOutElements)
            getReadyLabel.run(fadeOutElements)
            scoreLabel.run(fadeInElements)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func killPlayer() {
        scene?.run(SoundManager.sharedInstance.soundHit)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            self.scene?.run(SoundManager.sharedInstance.soundDie)
        })
        playing = false
        entityManager.spawnOn = false
        player.stopAnimation()
        
        //Stop all pipe movement actions
        self.enumerateChildNodes(withName: "Pipe") {
            (node, stop) in
            
            node.isPaused = true
        }
        //Stop the ground movement action
        self.enumerateChildNodes(withName: "*Ground*") {
            (node, stop) in
            node.isPaused = true
        }
        //Stop the goal node movement actions
        self.enumerateChildNodes(withName: "Goal") {
            (node, stop) in
            node.isPaused = true
        }
        
        let fadeOutElements = SKAction.fadeOut(withDuration: 0.1)
        let fadeInElements = SKAction.fadeIn(withDuration: 0.3)
        
        gameOverLabel.run(fadeInElements)
        scoreLabel.run(fadeOutElements)
        
        if let showScoreCard = SKAction(named: "ShowScoreCard") {
            scoreCard.updateScores(score: scoreLabel.score)
            scoreCard.run(showScoreCard)
        }
    }
    
    //MARK: StartButtonDelegate methods
    func startGame() {
        let fadeOutElements = SKAction.fadeOut(withDuration: 0.5)
        let fadeInElements = SKAction.fadeIn(withDuration: 0.5)
        
        if(!playing) {
            playing = true
            startUpDelta = startUpDelay
            
            //Fade out the title elements
            mainLogo.run(fadeOutElements)
            startButton.run(fadeOutElements)
            
            //Fade in the instructions
            instructions.run(fadeInElements)
            getReadyLabel.run(fadeInElements)
            
            self.physicsWorld.speed = 1.0
        }
    }
    
    //MARK: RestartButtonDelegate Methods
    func restartGame() {
        guard let resetScene = GameScene(fileNamed: "GameScene") else {
            return
        }
        resetScene.size = self.size
        resetScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view!.presentScene(resetScene, transition: transition)
    }
    
    //MARK: SKPhysicsContactDelegate methods
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else {
            return
        }
        
        guard let nodeB = contact.bodyB.node else {
            return
        }
        
        if nodeA.name == "Pipe" && nodeB.name == "Player" && playing {
            killPlayer()
        }
        
        if nodeA.name!.contains("Ground") && nodeB.name == "Player" && playing {
            killPlayer()
        }
        
        if nodeA.name == "Goal" && nodeB.name == "Player" {
            scoreLabel.incrementScore()
            scene?.run(SoundManager.sharedInstance.soundPoint)
            contact.bodyA.node?.removeFromParent()
        }
    }
}
