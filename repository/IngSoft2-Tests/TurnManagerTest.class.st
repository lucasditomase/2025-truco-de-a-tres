Class {
    #name : 'TurnManagerTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
TurnManagerTest >> testAdvanceTurnCyclesAndIncrementsTurn [
    | ship1 ship2 manager |
    ship1 := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    manager := TurnManager withShips: { ship1 . ship2 }.
    manager advanceTurn.
    self assert: 2 equals: manager currentTurnIndex.
    self assert: 2 equals: manager turn.
    self assert: ship2 equals: manager currentShip.
    manager advanceTurn.
    self assert: 1 equals: manager currentTurnIndex.
    self assert: 3 equals: manager turn.
    self assert: ship1 equals: manager currentShip.
]

{ #category : 'tests' }
TurnManagerTest >> testInitializeWithShipsReturnsSelf [
    | ship1 ship2 manager result |
    ship1 := Spaceship withName: 'X'.
    ship2 := Spaceship withName: 'Y'.
    manager := TurnManager new.
    result := manager initializeWithShips: { ship1 . ship2 }.
    self assert: manager equals: result.
    self assert: 1 equals: manager currentTurnIndex.
    self assert: 1 equals: manager turn.
    self assert: ship1 equals: manager currentShip.
]

{ #category : 'tests' }
TurnManagerTest >> testWithShipsInitializesCorrectly [
    | ship1 ship2 manager |
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    manager := TurnManager withShips: { ship1 . ship2 }.
    self assert: 1 equals: manager turn.
    self assert: 1 equals: manager currentTurnIndex.
    self assert: ship1 equals: manager currentShip.
]
