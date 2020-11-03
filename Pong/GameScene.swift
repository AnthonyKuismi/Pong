//
//  GameScene.swift
//  Pong
//
//  Created by 90308589 on 9/3/20.
//  Copyright © 2020 Anthony Kuismi. All rights reserved.
//

import SpriteKit
import GameplayKit
extension SKSpriteNode {

    func addGlow(radius: Float = 60) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}
class GameScene: SKScene,SKPhysicsContactDelegate {
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var scoreMain = 0;
    var scoreEnemy = 0;
    var enemyLabel = SKLabelNode()
    var mainLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        enemyLabel = self.childNode(withName: "enemyLabel") as! SKLabelNode
        mainLabel = self.childNode(withName: "mainLabel") as! SKLabelNode
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        main.name = "paddlemain"
        enemy.name = "paddleenemy"
        ball.addGlow()
        let border = SKPhysicsBody(edgeLoopFrom: self.frame )
        border.friction = 0;
        border.restitution = 1;
        self.physicsBody = border;
        physicsWorld.contactDelegate = self
        
        startGame()
            }
    override func update(_ currentTime: TimeInterval) {
    
        enemy.run(SKAction.moveTo(x: ball.position.x, duration:
            1.0))
        if ball.position.y < main.position.y{
            scoreEnemy = scoreEnemy + 1;
            resetball()
        } else if ball.position.y > enemy.position.y{
            scoreMain = scoreMain + 1;
            resetball()
        }
        addEmiter(loc: ball.position, file: "ballparticles")
        enemyLabel.text = "\(scoreEnemy)";
        mainLabel.text = "\(scoreMain)";
    }
    
    func startGame(){
        scoreMain = 0;
        scoreEnemy = 0;
        resetball()
    }
    func resetball(){
        ball.position.x = 0;
        ball.position.y = 0;
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration:
                       0))
        }
    }
    
    func addEmiter(loc: CGPoint,file:String){
       // let file = "firstParticle";
        let emitter = SKEmitterNode(fileNamed: file)
        emitter?.name = "emitter"
        emitter?.zPosition = 2;
        emitter?.position = CGPoint(x: loc.x, y: loc.y )
        addChild(emitter!)
        
        emitter?.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),SKAction.removeFromParent()]))
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
                  let location = touch.location(in: self)
                  main.run(SKAction.moveTo(x: location.x, duration:
                    0.1))
              }
    }
    func collision(between object: SKNode, object2: SKNode){
        if object2.name == "paddlemain"{
            addEmiter(loc: object.position, file:"firstParticle")
            rebound()
        }else if object2.name == "paddleenemy"{
            addEmiter(loc: object.position, file:"secondParticle")
            rebound()
        }
        
    }
    func rebound(){
        ball.physicsBody?.applyImpulse(CGVector(dx: Int(arc4random_uniform(2))*10, dy: 0))
    }
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "ball"{
            collision(between: nodeA, object2: nodeB)
        } else if nodeB.name == "ball"{
            collision(between: nodeB, object2: nodeA)
        }
    }
}
