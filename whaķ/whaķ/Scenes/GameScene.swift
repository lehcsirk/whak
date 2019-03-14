//
//  GameScene.swift
//  whaķ
//
//  Created by Cameron Krischel on 3/10/19.
//  Copyright © 2019 Cameron Krischel. All rights reserved.
//

import SpriteKit

extension SKSpriteNode
{
    func drawBorder(color: UIColor, width: CGFloat)
    {
        //        circle.position = CGPoint(x: frame.midX, y: frame.midY*1.75)
        let shapeNode = SKShapeNode(rect: CGRect(x: frame.width/2 - frame.width, y:  -1 * frame.height/2, width: frame.width, height: frame.height))
        shapeNode.fillColor = color
        shapeNode.zPosition = 2
        shapeNode.strokeColor = color
        shapeNode.lineWidth = 0//width
        addChild(shapeNode)
    }
}

extension SKTexture
{
    var name : String
    {
        return self.description.slice(start: "'",to: "'")!
    }
}

extension String {
    func slice(start: String, to: String) -> String?
    {
        
        return (range(of: start)?.upperBound).flatMap
            {
                sInd in
                (range(of: to, range: sInd..<endIndex)?.lowerBound).map
                    {
                        eInd in
                        substring(with:sInd..<eInd)
                        
                }
        }
    }
}

class GameScene: SKScene
{
    var updateRate = 0.002*5
    var stepSize = CGFloat(5)
    var timer: Timer?
    var touchLocation = CGPoint()
    
    var currentDirection = "up"
    var currentEncounter = "nil"
    var recentlyBumped = false
    
    // Array of all Collision Objects
    var collisionArray: [SKSpriteNode] = [SKSpriteNode]()
    var foodArray: [SKSpriteNode] = [SKSpriteNode]()
    
    
    // Character
    var circle: SKSpriteNode!
    var hpBar = UILabel()
    
    // Bullet
    var bulletTimer = Timer()
    var bullet: SKSpriteNode!
    var bulletArray: [SKSpriteNode] = [SKSpriteNode]()
    var bulletDirectionArray: [String] = [String]()
    
    
    // Notification Box
    var notifyBorder: SKSpriteNode!
    let notificationBox = UILabel()
    
    // D-PAD
    
    
    let dPadCircle = UILabel()
    let upButton = UILabel()
    let downButton = UILabel()
    let leftButton = UILabel()
    let rightButton = UILabel()
    let topLeft = UILabel()
    let topRight = UILabel()
    let botLeft = UILabel()
    let botRight = UILabel()
    
    let aButton = UIButton()
    let bButton = UIButton()
    
    
    var goingUp = false
    var goingDown = false
    var goingLeft = false
    var goingRight = false
    
    override func didMove(to view: SKView)
    {
        layoutScene()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            touchLocation = touch.location(in: self)
            
            if(touchLocation.x > upButton.frame.minX && touchLocation.x < upButton.frame.maxX
                && frame.height-touchLocation.y > upButton.frame.minY && frame.height-touchLocation.y < upButton.frame.maxY)
            {
                moveUp()
            }
            else
            {
                stopUp()
            }
            if(touchLocation.x > downButton.frame.minX && touchLocation.x < downButton.frame.maxX
                && frame.height-touchLocation.y > downButton.frame.minY && frame.height-touchLocation.y < downButton.frame.maxY)
            {
                moveDown()
            }
            else
            {
                stopDown()
            }
            if(touchLocation.x > leftButton.frame.minX && touchLocation.x < leftButton.frame.maxX
                && frame.height-touchLocation.y > leftButton.frame.minY && frame.height-touchLocation.y < leftButton.frame.maxY)
            {
                moveLeft()
            }
            else
            {
                stopLeft()
            }
            if(touchLocation.x > rightButton.frame.minX && touchLocation.x < rightButton.frame.maxX
                && frame.height-touchLocation.y > rightButton.frame.minY && frame.height-touchLocation.y < rightButton.frame.maxY)
            {
                moveRight()
            }
            else
            {
                stopRight()
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            touchLocation = touch.location(in: self)
            stopUp()
            stopDown()
            stopLeft()
            stopRight()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            touchLocation = touch.location(in: self)
            
            if(touchLocation.x > upButton.frame.minX && touchLocation.x < upButton.frame.maxX
                && frame.height-touchLocation.y > upButton.frame.minY && frame.height-touchLocation.y < upButton.frame.maxY)
            {
                moveUp()
            }
            else
            {
                stopUp()
            }
            if(touchLocation.x > downButton.frame.minX && touchLocation.x < downButton.frame.maxX
                && frame.height-touchLocation.y > downButton.frame.minY && frame.height-touchLocation.y < downButton.frame.maxY)
            {
                moveDown()
            }
            else
            {
                stopDown()
            }
            if(touchLocation.x > leftButton.frame.minX && touchLocation.x < leftButton.frame.maxX
                && frame.height-touchLocation.y > leftButton.frame.minY && frame.height-touchLocation.y < leftButton.frame.maxY)
            {
                moveLeft()
            }
            else
            {
                stopLeft()
            }
            if(touchLocation.x > rightButton.frame.minX && touchLocation.x < rightButton.frame.maxX
                && frame.height-touchLocation.y > rightButton.frame.minY && frame.height-touchLocation.y < rightButton.frame.maxY)
            {
                moveRight()
            }
            else
            {
                stopRight()
            }
        }
    }
    
    func makeWalls()
    {
        // Init multiple Walls
        for i in 0...2
        {
            let yCoord = Int(frame.height/7)*(i+3)       //Int.random(in: Int(frame.height*5/16) ..< Int(frame.height*13/16))
            let xCoord = Int(frame.width/2)     //Int.random(in: 0 ..< Int(frame.width))
            
            let size = 16//Int.random(in: 6 ..< 16)
            
            let myWall = SKSpriteNode(imageNamed: "mineGrass")
            myWall.name = String("wall")
            myWall.size = CGSize(width: Int(frame.size.width)*10/size, height: Int(frame.size.width)/size)
            myWall.position = CGPoint(x: xCoord, y: yCoord)
            //myWall.drawBorder(color: .brown, width: 1)
            addChild(myWall)
            collisionArray.insert(myWall, at: 0)
        }
    }
    func makeEnemies()
    {
        for i in 0...2
        {
            let yCoord = Int(frame.height*11/14)       //Int.random(in: Int(frame.height*5/16) ..< Int(frame.height*13/16))
            let xCoord = Int(frame.width/7)*(i+3)      //Int.random(in: 0 ..< Int(frame.width))
            
            let size = 16//Int.random(in: 6 ..< 16)
            
            let myEnemy = SKSpriteNode(imageNamed: "miniSentry")
            myEnemy.name = String("enemy")
            myEnemy.size = CGSize(width: Int(frame.size.width)/size, height: Int(frame.size.width)/size)
            myEnemy.position = CGPoint(x: xCoord, y: yCoord)
            //myEnemy.drawBorder(color: .red, width: 1)
            addChild(myEnemy)
            collisionArray.insert(myEnemy, at: 0)
        }
    }
    
    func makeFood()
    {
        // Init multiple square Food Objects
        for i in 0...10
        {
            let yCoord = Int.random(in: Int(frame.height*3/7) ..< Int(frame.height*5/7))
            let xCoord = Int.random(in: Int(frame.width)*1/16 ..< Int(frame.width)*15/16)
            
            let myFood = SKSpriteNode(imageNamed: "Sandvich")
            myFood.name = String("food")
            myFood.size = CGSize(width: Int(frame.size.width)/16+1, height: Int(frame.size.width)/16+1)
            myFood.position = CGPoint(x: xCoord, y: yCoord)
            //myFood.drawBorder(color: .green, width: 1)
            addChild(myFood)
            collisionArray.insert(myFood, at: 0)
        }
    }
    
    func checkFoodEmpty() -> Bool
    {
        var empty = true
        if(collisionArray.count > 0)
        {
            for i in 0...collisionArray.count - 1
            {
                if(collisionArray[i].name == "food")
                {
                    empty = false
                }
            }
        }
        return empty
    }
    func checkEnemyEmpty() -> Bool
    {
        var empty = true
        if(collisionArray.count > 0)
        {
            for i in 0...collisionArray.count - 1
            {
                if(collisionArray[i].name == "enemy")
                {
                    empty = false
                }
            }
        }
        return empty
    }
    
    func makeNotifyBox()
    {
        // Notification text box
        notificationBox.text = "Notify"
        notificationBox.textColor = UIColor.black
        
        var notifySize = CGFloat(50.0)
        notificationBox.font = UIFont.boldSystemFont(ofSize: notifySize*3/4)
        notificationBox.adjustsFontSizeToFitWidth = true
        notificationBox.minimumScaleFactor = 0.02
        notificationBox.numberOfLines = 1 // or 1
        
        notificationBox.textAlignment = .center
        var myInset = 10
        notificationBox.frame = CGRect(x: myInset/2, y: myInset/2, width: Int(frame.size.width) - myInset, height: Int(frame.size.height/8) - myInset)
        notificationBox.layer.borderColor = UIColor.white.cgColor
        notificationBox.layer.borderWidth = 1
        notificationBox.layer.cornerRadius = 0
        notificationBox.backgroundColor = UIColor.white
        
        let notifyBorder = SKSpriteNode(imageNamed: "UpArrow")
        notifyBorder.size = CGSize(width: frame.size.width, height: frame.size.height/8)
        notifyBorder.position = CGPoint(x: frame.midX, y: frame.size.height * 15 / 16) // + CGFloat(myInset))
        notifyBorder.drawBorder(color: UIColor.purple, width: 1)
        notifyBorder.name = "notifyBox"
        addChild(notifyBorder)
        collisionArray.insert(notifyBorder, at: 0)

        
        
        self.view!.addSubview(notificationBox)
    }
    func makeHPBar()
    {
        hpBar.frame = CGRect(x: Int(frame.width*2/32), y: Int(frame.size.height*1/64), width: Int(frame.width/4), height: Int(frame.width/24))
        hpBar.backgroundColor = UIColor.green
        self.view!.addSubview(hpBar)
    }
    
    func makeDPad()
    {
        //===============================================================D-PAD===============================================================//
        var buttonSpacing = frame.size.width*2.5/16
        var buttonSize = CGFloat(100.0)
        var centerGap = frame.size.width*1/64
        // Draws circle
        dPadCircle.frame = CGRect(x: 0, y: 0, width: buttonSpacing*3.11111111, height: buttonSpacing*3.11111111)
        dPadCircle.layer.borderColor = UIColor.black.cgColor
        dPadCircle.layer.borderWidth = 1
        dPadCircle.layer.cornerRadius = dPadCircle.frame.width/2
        dPadCircle.center.x = frame.size.width*0.25
        dPadCircle.center.y = frame.size.height*0.8
        self.view!.addSubview(dPadCircle)
        
        // Up Label
        upButton.text = "↑"
        upButton.textColor = UIColor.gray
        upButton.font = UIFont.systemFont(ofSize: buttonSize)
        upButton.textAlignment = .center
        upButton.adjustsFontForContentSizeCategory = true
        upButton.numberOfLines = 0
        upButton.frame = CGRect(x: 0, y: 0, width: buttonSpacing*3.11111111, height: buttonSpacing*1.11111111 + centerGap)
//        upButton.layer.borderColor = UIColor.black.cgColor
//        upButton.layer.borderWidth = 1
        upButton.center.x = frame.size.width*0.25
        upButton.center.y = frame.size.height*0.8 - buttonSpacing + centerGap/2
        self.view!.addSubview(upButton)
        
        // Down Label
        downButton.text = "↑"
        downButton.textColor = UIColor.gray
        downButton.font = UIFont.systemFont(ofSize: buttonSize)
        downButton.textAlignment = .center
        downButton.adjustsFontForContentSizeCategory = true
        downButton.numberOfLines = 0
        downButton.frame = CGRect(x: 0, y: 0, width: buttonSpacing*3.11111111, height: buttonSpacing*1.11111111 + centerGap)
//        downButton.layer.borderColor = UIColor.black.cgColor
//        downButton.layer.borderWidth = 1
        downButton.center.x = frame.size.width*0.25
        downButton.center.y = frame.size.height*0.8 + buttonSpacing - centerGap/2
        downButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.view!.addSubview(downButton)
        
        // Left Label
        leftButton.text = "↑"
        leftButton.textColor = UIColor.gray
        leftButton.font = UIFont.systemFont(ofSize: buttonSize)
        leftButton.textAlignment = .center
        leftButton.adjustsFontForContentSizeCategory = true
        leftButton.numberOfLines = 0
        leftButton.frame = CGRect(x: 0, y: 0, width: buttonSpacing*3.11111111, height: buttonSpacing*1.11111111 + centerGap)
//        leftButton.layer.borderColor = UIColor.black.cgColor
//        leftButton.layer.borderWidth = 1
        leftButton.center.x = frame.size.width*0.25 - buttonSpacing + centerGap/2
        leftButton.center.y = frame.size.height*0.8
        leftButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -1 / 2)
        self.view!.addSubview(leftButton)
        
        // Right Label
        rightButton.text = "↑"
        rightButton.textColor = UIColor.gray
        rightButton.font = UIFont.systemFont(ofSize: buttonSize)
        rightButton.textAlignment = .center
        rightButton.adjustsFontForContentSizeCategory = true
        rightButton.numberOfLines = 0
        rightButton.frame = CGRect(x: 0, y: 0, width: buttonSpacing*3.11111111, height: buttonSpacing*1.11111111 + centerGap)
//        rightButton.layer.borderColor = UIColor.black.cgColor
//        rightButton.layer.borderWidth = 1
        rightButton.center.x = frame.size.width*0.25 + buttonSpacing - centerGap/2
        rightButton.center.y = frame.size.height*0.8
        rightButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1 / 2)
        self.view!.addSubview(rightButton)
        
        // Top Left Label
        topLeft.text = "↑"
        topLeft.textColor = UIColor.gray
        topLeft.font = UIFont.systemFont(ofSize: buttonSize*3/4)
        topLeft.textAlignment = .center
        topLeft.adjustsFontSizeToFitWidth = true
        topLeft.numberOfLines = 0
        topLeft.frame = CGRect(x: 0, y: 0, width: buttonSpacing*1.11111111*3/4, height: buttonSpacing*1.11111111*3/4)
        topLeft.center.x = frame.size.width*0.25 - buttonSpacing*2/4 - centerGap
        topLeft.center.y = frame.size.height*0.8 - buttonSpacing*2/4 - centerGap
        topLeft.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -1 / 4)
        self.view!.addSubview(topLeft)
        
        // Top Right Label
        topRight.text = "↑"
        topRight.textColor = UIColor.gray
        topRight.font = UIFont.systemFont(ofSize: buttonSize*3/4)
        topRight.textAlignment = .center
        topRight.adjustsFontSizeToFitWidth = true
        topRight.numberOfLines = 0
        topRight.frame = CGRect(x: 0, y: 0, width: buttonSpacing*1.11111111*3/4, height: buttonSpacing*1.11111111*3/4)
        topRight.center.x = frame.size.width*0.25 + buttonSpacing*2/4 + centerGap
        topRight.center.y = frame.size.height*0.8 - buttonSpacing*2/4 - centerGap
        topRight.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1 / 4)
        self.view!.addSubview(topRight)
        
        // Bottom Left Label
        botLeft.text = "↑"
        botLeft.textColor = UIColor.gray
        botLeft.font = UIFont.systemFont(ofSize: buttonSize*3/4)
        botLeft.textAlignment = .center
        botLeft.adjustsFontSizeToFitWidth = true
        botLeft.numberOfLines = 0
        botLeft.frame = CGRect(x: 0, y: 0, width: buttonSpacing*1.11111111*3/4, height: buttonSpacing*1.11111111*3/4)
        botLeft.center.x = frame.size.width*0.25 - buttonSpacing*2/4 - centerGap
        botLeft.center.y = frame.size.height*0.8 + buttonSpacing*2/4 + centerGap
        botLeft.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -3 / 4)
        self.view!.addSubview(botLeft)
        
        // Bottom Right Label
        botRight.text = "↑"
        botRight.textColor = UIColor.gray
        botRight.font = UIFont.systemFont(ofSize: buttonSize*3/4)
        botRight.textAlignment = .center
        botRight.adjustsFontSizeToFitWidth = true
        botRight.numberOfLines = 0
        botRight.frame = CGRect(x: 0, y: 0, width: buttonSpacing*1.11111111*3/4, height: buttonSpacing*1.11111111*3/4)
        botRight.center.x = frame.size.width*0.25 + buttonSpacing*2/4 + centerGap
        botRight.center.y = frame.size.height*0.8 + buttonSpacing*2/4 + centerGap
        botRight.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 3 / 4)
        self.view!.addSubview(botRight)
        
        //===============================================================A/B===============================================================//
        // A Button
        aButton.setTitle("A", for: .normal)
        aButton.setTitleColor(UIColor.gray, for: .normal)
        aButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonSize*3/4)
        aButton.titleLabel?.textAlignment = .center
        aButton.frame = CGRect(x: 0, y: 0, width: frame.size.width/6, height: frame.size.width/6)
        aButton.layer.borderColor = UIColor.black.cgColor
        aButton.layer.borderWidth = 1
        aButton.layer.cornerRadius = aButton.frame.width/2
        aButton.center.x = frame.size.width*0.75 + buttonSpacing
        aButton.center.y = frame.size.height*0.8
        aButton.addTarget(self, action: #selector(aButtonAction), for: .touchDown)
        
        self.view!.addSubview(aButton)
        
        // B Button
        bButton.setTitle("B", for: .normal)
        bButton.setTitleColor(UIColor.gray, for: .normal)
        bButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonSize*3/4)
        bButton.titleLabel?.textAlignment = .center
        bButton.frame = CGRect(x: 0, y: 0, width: frame.size.width/6, height: frame.size.width/6)
        bButton.layer.borderColor = UIColor.black.cgColor
        bButton.layer.borderWidth = 1
        bButton.layer.cornerRadius = aButton.frame.width/2
        bButton.center.x = frame.size.width*0.75 - buttonSpacing*1/4
        bButton.center.y = frame.size.height*0.8 + buttonSpacing
        bButton.addTarget(self, action: #selector(bButtonAction), for: [.touchDown])
        bButton.addTarget(self, action: #selector(bButtonCancel), for: [.touchUpInside])

        self.view!.addSubview(bButton)
    }
    
    func layoutScene()
    {
        //backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        backgroundColor = UIColor.white
        
        // Generate necessary elements
        makeWalls()
        makeEnemies()
        makeFood()
        
        // Initialize Main Character
        circle = SKSpriteNode(imageNamed: "Pootis")
        circle.size = CGSize(width: frame.size.width/16, height: frame.size.width/16)
        circle.position = CGPoint(x: frame.midX, y: frame.midY*1.625)
        //circle.drawBorder(color: UIColor.black, width: 1)
        addChild(circle)
        
        
        makeNotifyBox()
        makeHPBar()
        makeDPad()
        
        timer = Timer.scheduledTimer(timeInterval: updateRate, target: self, selector: #selector(updatePosition), userInfo: nil, repeats: true)
        bulletTimer = Timer.scheduledTimer(timeInterval: updateRate*1/2, target: self, selector: #selector(updateBulletPos), userInfo: nil, repeats: true)
    }
    
    
    
    @objc func aButtonAction()
    {
        checkForNPCOrLoot()
    }
    @objc func bButtonAction()
    {
        notificationBox.text = "PEW!"
        shoot()
    }
    @objc func bButtonCancel()
    {
        //updateRate = 0.002
    }
    
    @objc func shoot()
    {
        bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: frame.size.width/32, height: frame.size.width/16)
        bullet.position = CGPoint(x: circle.position.x, y: circle.position.y)
        bullet.zRotation = circle.zRotation
        addChild(bullet)
        bulletArray.insert(bullet, at: 0)
        bulletDirectionArray.insert(currentDirection, at: 0)
    }
    @objc func updateBulletPos()
    {
        if(!bulletArray.isEmpty)
        {
            for i in 0...bulletArray.count-1
            {
                if(bulletDirectionArray[i] == "right")
                {
                    bulletArray[i].position.x += stepSize
                    if(bulletArray[i].position.x > frame.size.width + frame.size.width/16)
                    {
                        bulletArray[i].removeFromParent()
                        bulletArray.remove(at: i)
                        bulletDirectionArray.remove(at: i)
                        break
                    }
                }
                if(bulletDirectionArray[i] == "left")
                {
                    bulletArray[i].position.x -= stepSize
                    if(bulletArray[i].position.x < 0 - frame.size.width/16)
                    {
                        bulletArray[i].removeFromParent()
                        bulletArray.remove(at: i)
                        bulletDirectionArray.remove(at: i)
                        break
                    }
                }
                if(bulletDirectionArray[i] == "up")
                {
                    bulletArray[i].position.y += stepSize
                    if(bulletArray[i].position.y > frame.size.height + frame.size.height/16)
                    {
                        bulletArray[i].removeFromParent()
                        bulletArray.remove(at: i)
                        bulletDirectionArray.remove(at: i)
                        break
                    }
                }
                if(bulletDirectionArray[i] == "down")
                {
                    bulletArray[i].position.y -= stepSize
                    if(bulletArray[i].position.y < 0 - frame.size.height/16)
                    {
                        bulletArray[i].removeFromParent()
                        bulletArray.remove(at: i)
                        bulletDirectionArray.remove(at: i)
                        break
                    }
                }
            }
        }
        if(!collisionArray.isEmpty && !bulletArray.isEmpty)
        {
            outerLoop: for i in 0...collisionArray.count - 1
            {
                for j in 0...bulletArray.count - 1
                {
                    if(collisionArray[i].name == "enemy")
                    {
                        if(bulletArray[j].intersects(collisionArray[i]))
                        {
                            notificationBox.text = "BOOM. ENEMY DESTROYED."
                            collisionArray[i].removeFromParent()
                            collisionArray[i].removeAllActions()
                            collisionArray.remove(at: i)
                            bulletArray[j].removeFromParent()
                            bulletArray.remove(at: j)
                            bulletDirectionArray.remove(at: j)
                            break outerLoop
                        }
                    }
                    if(collisionArray[i].name == "wall")
                    {
                        if(bulletArray[j].intersects(collisionArray[i]))
                        {
                            notificationBox.text = "You shot a wall. Good job."
                            bulletArray[j].removeFromParent()
                            bulletArray.remove(at: j)
                            bulletDirectionArray.remove(at: j)
                            break outerLoop
                        }
                    }
                    if(collisionArray[i].name == "notifyBox")
                    {
                        if(bulletArray[j].intersects(collisionArray[i]))
                        {
                            notificationBox.text = "Ow. Stop shooting me."
                            bulletArray[j].removeFromParent()
                            bulletArray.remove(at: j)
                            bulletDirectionArray.remove(at: j)
                            break outerLoop
                        }
                    }
                    if(collisionArray[i].name == "food")
                    {
                        if(bulletArray[j].intersects(collisionArray[i]))
                        {
                            notificationBox.text = "LONG RANGE FOOD GRAB!"
                            collisionArray[i].removeFromParent()
                            collisionArray[i].removeAllActions()
                            collisionArray.remove(at: i)
                            bulletArray[j].removeFromParent()
                            bulletArray.remove(at: j)
                            bulletDirectionArray.remove(at: j)
                            break outerLoop
                        }
                    }
                }
            }
        }
    }
    
    @objc func increaseHP()
    {
        if(Int(hpBar.frame.width) >= Int(frame.width*13/16))
        {
        notificationBox.text = "Max HP!!!"
        }
        else
        {
        hpBar.frame = CGRect(x: Int(frame.width*2/32), y: Int(frame.size.height*1/64), width: Int(hpBar.frame.width) + Int(frame.width/16), height: Int(frame.width/24))
        }
    }
    @objc func decreaseHP()
    {
        if(Int(hpBar.frame.width) >= Int(frame.width*1/16))
        {
        hpBar.frame = CGRect(x: Int(frame.width*2/32), y: Int(frame.size.height*1/64), width: Int(hpBar.frame.width) - Int(frame.width/16), height: Int(frame.width/24))
        }
        if(Int(hpBar.frame.width) <= Int(frame.width*1/16))
        {
        notificationBox.text = "You're out of HP!!!"
        }
    }
    
    @objc func checkForNPCOrLoot()
    {
        if(recentlyBumped)
        {
            print("You encountered an \(currentEncounter) \(currentDirection)")
            notificationBox.text = "You encountered an \(currentEncounter) \(currentDirection)."
            if(currentEncounter == "enemy")
            {
                decreaseHP()
            }
        }
        else
        {
            print("There's nothing there.")
            notificationBox.text = "There's nothing there."
        }
    }
    
    @objc func updatePosition()
    {
        if(checkFoodEmpty())
        {
            makeFood()
        }
        if(checkEnemyEmpty())
        {
            makeEnemies()
        }
        if(goingUp)
        {
            recentlyBumped = false
            let length = collisionArray.count-1
            
            // Move the circle
            circle.position.y += stepSize
            // If there are any objects to check for
            if(!collisionArray.isEmpty)
            {
                for var i in 0...length
                {
                    // If the new position overlaps
                    if(circle.intersects(collisionArray[i]))
                    {
                        // Set current encounter
                        currentEncounter = collisionArray[i].name!
                        // If it's food eat it
                        if(collisionArray[i].name == "food")
                        {
                            collisionArray[i].removeFromParent()
                            collisionArray[i].removeAllActions()
                            collisionArray.remove(at: i)
                            notificationBox.text = "NOM NOM NOM..."
                            increaseHP()
                            break
                        }
                        // Yes recently bumped
                        recentlyBumped = true
                        // Move back
                        while(circle.intersects(collisionArray[i]))
                        {
                            circle.position.y -= 1
                        }
                    }
                }
            }
        }
        if(goingDown)
        {
            recentlyBumped = false
            let length = collisionArray.count-1
            
            // Move the circle
            circle.position.y -= stepSize
            // If there are any objects to check for
            if(!collisionArray.isEmpty)
            {
                for var i in 0...length
                {
                    // If the new position overlaps
                    if(circle.intersects(collisionArray[i]))
                    {
                        // Set current encounter
                        currentEncounter = collisionArray[i].name!
                        // If it's food eat it
                        if(collisionArray[i].name == "food")
                        {
                            collisionArray[i].removeFromParent()
                            collisionArray[i].removeAllActions()
                            collisionArray.remove(at: i)
                            notificationBox.text = "NOM NOM NOM..."
                            increaseHP()
                            break
                        }
                        // Yes recently bumped
                        recentlyBumped = true
                        // Move back
                        while(circle.intersects(collisionArray[i]))
                        {
                            circle.position.y += 1
                        }
                    }
                }
            }
        }
        if(goingLeft)
        {
            recentlyBumped = false
            let length = collisionArray.count-1
            
            // Move the circle
            circle.position.x -= stepSize
            // If there are any objects to check for
            if(!collisionArray.isEmpty)
            {
                for var i in 0...length
                {
                    // If the new position overlaps
                    if(circle.intersects(collisionArray[i]))
                    {
                        // Set current encounter
                        currentEncounter = collisionArray[i].name!
                        // If it's food eat it
                        if(collisionArray[i].name == "food")
                        {
                            collisionArray[i].removeFromParent()
                            collisionArray[i].removeAllActions()
                            collisionArray.remove(at: i)
                            notificationBox.text = "NOM NOM NOM..."
                            increaseHP()
                            break
                        }
                        // Yes recently bumped
                        recentlyBumped = true
                        // Move back
                        while(circle.intersects(collisionArray[i]))
                        {
                            circle.position.x += 1
                        }
                    }
                }
            }
        }
        if(goingRight)
        {
            recentlyBumped = false
            let length = collisionArray.count-1
            
            // Move the circle
            circle.position.x += stepSize
            // If there are any objects to check for
            if(!collisionArray.isEmpty)
            {
                for var i in 0...length
                {
                    // If the new position overlaps
                    if(circle.intersects(collisionArray[i]))
                    {
                        // Set current encounter
                        currentEncounter = collisionArray[i].name!
                        // If it's food eat it
                        if(collisionArray[i].name == "food")
                        {
                            collisionArray[i].removeFromParent()
                            collisionArray[i].removeAllActions()
                            collisionArray.remove(at: i)
                            notificationBox.text = "NOM NOM NOM..."
                            increaseHP()
                            break
                        }
                        // Yes recently bumped
                        recentlyBumped = true
                        // Move back
                        while(circle.intersects(collisionArray[i]))
                        {
                            circle.position.x -= 1
                        }
                    }
                }
            }
        }
        if(circle.position.x > frame.width - circle.frame.width/2)
        {
            circle.position.x = frame.width - circle.frame.width/2
        }
        if(circle.position.x < 0 + circle.frame.width/2)
        {
            circle.position.x = 0 + circle.frame.width/2
        }
        if(circle.position.y > frame.height - circle.frame.height/2)
        {
            circle.position.y = frame.height - circle.frame.height/2
        }
        if(circle.position.y < 0 + circle.frame.height/2)
        {
            circle.position.y = 0 + circle.frame.height/2
        }
    }
    
    // TODO: SMALLER SPRITES TO REDUCE LAG
    @objc func moveUp()
    {
        goingUp = true
        circle.zRotation = 0
        notificationBox.text = "Walking Up."
        currentDirection = "up"
    }
    @objc func stopUp()
    {
        goingUp = false
        if(!goingUp && !goingDown && !goingLeft && !goingRight)
        {
            notificationBox.text = "Stopped Walking"
        }
    }
    @objc func moveDown()
    {
        goingDown = true
        circle.zRotation = CGFloat.pi
        notificationBox.text = "Walking Down."
        currentDirection = "down"
    }
    @objc func stopDown()
    {
        goingDown = false
        if(!goingUp && !goingDown && !goingLeft && !goingRight)
        {
            notificationBox.text = "Stopped Walking"
        }
    }
    @objc func moveLeft()
    {
        goingLeft = true
        circle.zRotation = CGFloat.pi * 1 / 2
        notificationBox.text = "Walking Left."
        currentDirection = "left"
    }
    @objc func stopLeft()
    {
        goingLeft = false
        if(!goingUp && !goingDown && !goingLeft && !goingRight)
        {
            notificationBox.text = "Stopped Walking"
        }
    }
    @objc func moveRight()
    {
        goingRight = true
        circle.zRotation = CGFloat.pi * -1 / 2
        notificationBox.text = "Walking Right."
        currentDirection = "right"
    }
    @objc func stopRight()
    {
        goingRight = false
        if(!goingUp && !goingDown && !goingLeft && !goingRight)
        {
            notificationBox.text = "Stopped Walking"
        }
    }
}
