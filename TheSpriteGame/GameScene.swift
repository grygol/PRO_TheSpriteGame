//
//  GameScene.swift
//  TheSpriteGame
//
//  Created by Michał Grygolec on 07/12/2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var airtags: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
//        let cameraNode = SKCameraNode()
//        cameraNode.position = CGPoint(x: cameraNode.frame.size.width / 2, y: cameraNode.frame.size.height / 2)
//
//        addChild(cameraNode)
//        camera = cameraNode
        
        let bg = SKSpriteNode(imageNamed: "wooden_floor")
        bg.blendMode = .replace
        bg.zPosition = -1
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(bg)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        let destroyer = SKShapeNode(rectOf: CGSize(width: 200, height: 10))
        destroyer.fillColor = .red
        destroyer.physicsBody = SKPhysicsBody(rectangleOf: destroyer.frame.size)
        destroyer.physicsBody?.isDynamic = false
        destroyer.position = CGPoint(x: 200, y: 100)
        destroyer.name = "destroyer"
        addChild(destroyer)
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        guard let bodyA = contact.bodyA.node else {return}
        guard let bodyB = contact.bodyB.node else {return}
        
        print("collision \(bodyA.name) \(bodyB.name)")
        
        if bodyA.name == "airtag" && bodyB.name == "destroyer"{
            bodyA.removeFromParent()
        } else if bodyB.name == "airtag" && bodyA.name == "destroyer"{
            bodyB.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let airtag = SKSpriteNode(imageNamed: "airtag")
            airtag.name = "airtag"
            airtag.position = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y)
            let clickedNotes = self.nodes(at: position)
            
            airtag.blendMode = .alpha
            airtag.physicsBody = SKPhysicsBody(circleOfRadius: airtag.size.width / 2)
            airtag.physicsBody?.affectedByGravity = false
            airtag.physicsBody?.contactTestBitMask = physicsBody!.collisionBitMask
            airtags.append(airtag)
            self.addChild(airtag)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !airtags.isEmpty {
                let activeAirtag = airtags.last
                activeAirtag?.position = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !airtags.isEmpty {
            let activeAirtag = airtags.last
            activeAirtag!.physicsBody?.affectedByGravity = true
            activeAirtag!.physicsBody?.restitution = 0.9
        }
    }
}
