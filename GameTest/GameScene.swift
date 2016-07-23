//
//  GameScene.swift
//  GameTest
//
//  Created by Chris Barry on 7/22/16.
//  Copyright © 2016 Chris Barry. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var isTouching: Bool = false
    var ball: BallNode!
    var touchPoint: CGPoint = CGPoint()
    var basket: SKNode!
    let basketCat : UInt32 = 1;
    let worldCategory : UInt32 = 2;
    let ballCat : UInt32 = 4;

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        physicsWorld.contactDelegate = self
        setupBasket()
    }

    func setupBasket() {
        basket = self.childNode(withName: "basket")
        basket.physicsBody?.categoryBitMask = basketCat;
        basket.physicsBody?.collisionBitMask = worldCategory;
        basket.physicsBody?.contactTestBitMask = worldCategory;
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        removeObject(name: "soccerball")
        placeNewBall(touches: touches)
    }

    func placeNewBall(touches: Set<UITouch>) {
        for touch: UITouch in touches {
            let location = touch.location(in: self)
            ball = BallNode.create(location: location)
            ball.physicsBody?.categoryBitMask = ballCat;
            ball.physicsBody?.contactTestBitMask = basketCat | worldCategory;
            ball.physicsBody?.collisionBitMask = worldCategory;
            if ball.frame.contains(location) {
                touchPoint = location
                isTouching = true
            }
            self.addChild(ball)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            let location = touch.location(in: self)
            touchPoint = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isTouching {
            if touchPoint != ball.position
            {
                let dt:CGFloat = 1.0/15.0
                let distance = CGVector(dx: touchPoint.x-ball.position.x, dy: touchPoint.y-ball.position.y)
                let vel = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
                ball.physicsBody!.velocity = vel
            }
        }
    }

    func removeObject(name: String) {
        ball = nil
        let oldObjects = self.children
        for obj: SKNode in oldObjects {
            if(obj.name == name){
                obj.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                           SKAction.removeFromParent()]))
            }
        }
    }

    func collisionBetweenBall(ball: SKNode, object: SKNode) {
        if object.name == "basket" && ball.physicsBody?.velocity.dy < 0 {
            (object as! SKSpriteNode).color = SKColor.blue()
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node!.name == "soccerball" {
            collisionBetweenBall(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node!.name == "soccerball" {
            collisionBetweenBall(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
}
