Class {
    #name : 'GameCoordinatorTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameCoordinatorTest >> testCoordinatorCreation [
    
    | ships board dice statuses coordinator |
    
    ships := { Spaceship withName: 'Apollo' . Spaceship withName: 'Discovery' }.
    board := Board of: 20.
    dice := DiceCup with: { Die of: 6 }.
    
    statuses := Dictionary new.
    ships do: [ :ship |
        statuses at: ship put: (ShipStatus for: ship position: 0 laps: 0 penalized: false) ].
    
    coordinator := GameCoordinator
        forBoard: board
        withShips: ships
        statuses: statuses
        andDice: dice.
    
    self assert: coordinator notNil.
    self assert: coordinator currentShip equals: ships first
]

{ #category : 'tests' }
GameCoordinatorTest >> testTurnAdvancement [
    
    | ships board dice statuses coordinator |
    
    ships := { Spaceship withName: 'Apollo' . Spaceship withName: 'Discovery' }.
    board := Board of: 20.
    dice := DiceCup with: { Die of: 6 }.
    
    statuses := Dictionary new.
    ships do: [ :ship |
        statuses at: ship put: (ShipStatus for: ship position: 0 laps: 0 penalized: false) ].
    
    coordinator := GameCoordinator
        forBoard: board
        withShips: ships
        statuses: statuses
        andDice: dice.
    
    self assert: coordinator currentShip equals: ships first.
    
    coordinator advanceTurn.
    
    self assert: coordinator currentShip equals: ships second
]

{ #category : 'tests' }
GameCoordinatorTest >> testLapRegistration [
    
    | ships board dice statuses coordinator ship status |
    
    ships := { Spaceship withName: 'Apollo' }.
    board := Board of: 10.
    dice := DiceCup with: { Die of: 6 }.
    
    ship := ships first.
    statuses := Dictionary new.
    statuses at: ship put: (ShipStatus for: ship position: 0 laps: 0 penalized: false).
    
    coordinator := GameCoordinator
        forBoard: board
        withShips: ships
        statuses: statuses
        andDice: dice.
    
    status := statuses at: ship.
    self assert: status lapCount equals: 0.
    
    coordinator registerLapFor: ship from: 5 after: 10.
    
    self assert: status lapCount equals: 1
]
