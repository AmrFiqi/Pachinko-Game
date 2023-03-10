//
//  GameScene.swift
//  Pachinko
//
//  Created by Amr El-Fiqi on 23/01/2023.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel:SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet{
            if editingMode{
                editLabel.text = "Done"
            }
            else{
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        // Assign the scene to be physics world contact delegate
        physicsWorld.contactDelegate = self
        
        // Set background picture to be shown at all time
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Set score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 650)
        addChild(scoreLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 650)
        addChild(editLabel)
        
        // Add Slots for points
        makeSlot(at: CGPoint(x: 128, y: 50), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 50), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 50), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 50), isGood: false)
        
        //Add bouncers
        makeBouncer(at: CGPoint(x: 0, y: 50))
        makeBouncer(at: CGPoint(x: 256, y: 50))
        makeBouncer(at: CGPoint(x: 512, y: 50))
        makeBouncer(at: CGPoint(x: 768, y: 50))
        makeBouncer(at: CGPoint(x: 1024, y: 50))
       
        
    }
    
    // Show touch location at the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        
        // Get all the nodes on the screen
        let objects = nodes(at: location)
        
        // Toggle between edit mode and play mode
        if objects.contains(editLabel){
            editingMode.toggle()
        }
        else{
            if editingMode{
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            }
            else{
                let ballColor = ["Red", "Green", "Cyan", "Blue", "Grey", "Yellow"]
                let ball = SKSpriteNode(imageNamed: "ball\(ballColor.randomElement() ?? "Red")")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
                ball.physicsBody?.restitution = 0.5
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                if location.y >= 600 {
                    ball.position = location
                }
                else{
                    var newLocation = location
                    newLocation.y = 600
                    ball.position = newLocation
                }
                
                ball.name = "ball"
                addChild(ball)
            }
        }
    }
    
    // Create a bouncer
    func makeBouncer(at position: CGPoint){
        let bouncer  = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot (at postion: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }
        else{
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = postion
        slotGlow.position = postion
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForver = SKAction.repeatForever(spin)
        slotGlow.run(spinForver)
    }
    
    func collision(between ball: SKNode, object: SKNode){
       
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        }
        else if object.name == "bad" {
            destroy(ball: ball)
            if score <= 0 {
                score = 0
            }
            else{
                score -= 1
            }
            
        }
    }
    // Make the ball disappear
    func destroy(ball: SKNode){
        if let fireParticles =  SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    // Check when contact happen
    func didBegin(_ contact: SKPhysicsContact) {
        // To make sure if a collision happens twice and ball is destroy the app doesn't crash with force unwrap
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}

        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
            
        }
        else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
