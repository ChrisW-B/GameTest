//
//  GameScene.swift
//  GameTest
//
//  Created by Chris Barry on 7/22/16.
//  Copyright © 2016 Chris Barry. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var isTouching: Bool = false
    var currentBall: BallNode!
    var touchPoint: CGPoint = CGPoint()

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -20)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        removeObject(name: "soccerball")
        placeNewBall(touches: touches)
    }

    func placeNewBall(touches: Set<UITouch>) {
        for touch: UITouch in touches {
            let location = touch.location(in: self)
            currentBall = BallNode.create(location: location)
            if currentBall.frame.contains(location) {
                touchPoint = location
                isTouching = true
            }
            self.addChild(currentBall)
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
            if touchPoint != currentBall.position
            {
                let dt:CGFloat = 1.0/15.0
                let distance = CGVector(dx: touchPoint.x-currentBall.position.x, dy: touchPoint.y-currentBall.position.y)
                let vel = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
                currentBall.physicsBody!.velocity = vel
            }
        }
    }

    func removeObject(name: String) {
        currentBall = nil
        let oldObjects = self.children
        for obj: SKNode in oldObjects {
            if(obj.name == name){
                obj.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                           SKAction.removeFromParent()]))
            }
        }
    }
}
