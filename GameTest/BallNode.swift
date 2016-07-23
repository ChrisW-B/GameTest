//
//  BallNode.swift
//  GameTest
//
//  Created by Chris Barry on 7/22/16.
//  Copyright © 2016 Chris Barry. All rights reserved.
//

import UIKit
import SpriteKit

class BallNode: SKSpriteNode {
    class func create(location: CGPoint) -> BallNode {
        let sprite = BallNode(imageNamed:"Soccerball")
        sprite.name = "soccerball"
        sprite.xScale = 0.25
        sprite.yScale = 0.25
        sprite.position = location
        sprite.run(SKAction.sequence([SKAction.wait(forDuration: 5),
                                    SKAction.fadeOut(withDuration: 0.5),
                                    SKAction.removeFromParent()]))
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.isDynamic = true;
            physics.linearDamping = 0.99
        }
        return sprite
    }
}
