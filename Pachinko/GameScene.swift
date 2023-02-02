//
//  GameScene.swift
//  Pachinko
//
//  Created by Amr El-Fiqi on 23/01/2023.
//

import SpriteKit


class GameScene: SKScene {
  
    
    override func didMove(to view: SKView) {
        // Set background picture to be shown at all time
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        
        //Add bouncers
        makeBouncer(at: CGPoint(x: 0, y: 50))
        makeBouncer(at: CGPoint(x: 256, y: 50))
        makeBouncer(at: CGPoint(x: 512, y: 50))
        makeBouncer(at: CGPoint(x: 768, y: 50))
        makeBouncer(at: CGPoint(x: 1024, y: 50))
       
        
        makeSlot(at: CGPoint(x: 128, y: 50), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 50), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 50), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 50), isGood: false)
    }
    
    // Show touch location at the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.restitution = 0.5
        ball.position = location
        addChild(ball)
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
        }
        else{
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        slotBase.position = postion
        slotGlow.position = postion
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForver = SKAction.repeatForever(spin)
        slotGlow.run(spinForver)
    }
}
