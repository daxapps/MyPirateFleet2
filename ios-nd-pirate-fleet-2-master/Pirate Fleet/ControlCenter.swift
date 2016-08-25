//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            // Hint: The cells getter should return an array of GridLocations.
            var occupiedCells = [GridLocation]()
            
            if isVertical == true {
                for y in start.y...end.y {
                    occupiedCells.append(GridLocation(x: start.x, y: y))
                }
            } else if isVertical == false {
                for x in start.x...end.x {
                    occupiedCells.append(GridLocation(x: x, y: start.y))
                }
            }
            return occupiedCells
        }
    }
    
    var hitTracker: HitTracker
    
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        
        for cells in hitTracker.cellsHit {
            if cells.1 == false {
                return false
            }
        }
        return true
    }

// TODO: Add custom initializers
    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical        
        self.isWooden = true
        self.hitTracker = HitTracker()
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var penaltyText: String { get }
    var guaranteesHit: Bool { get set }    
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    var penaltyText: String
    var guaranteesHit: Bool
    
    init(location:GridLocation, penaltyText: String) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = false
    }
    
    init(location: GridLocation, penaltyText: String, guaranteesHit: Bool) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = guaranteesHit
    }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var penaltyText: String
    var guaranteesHit: Bool
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true)
        //, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(smallShip)
//        print(smallShip.cells)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
        //, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip1)
//        print(mediumShip1.cells)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
        //, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true)
        //, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        //, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0), penaltyText: "BOOM! A mine has been hit.", guaranteesHit: false)
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "BOOM! A mine has been hit.", guaranteesHit: false)
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), penaltyText: "Whoa Nellie!", guaranteesHit: true)
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), penaltyText: "Whoa Nellie!", guaranteesHit: true)
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}