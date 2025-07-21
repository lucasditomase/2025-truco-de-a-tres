Class {
    #name : 'NullPositionManagerTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests - instance' }
NullPositionManagerTest >> testMoveShipBackwardMovesShipProperly [
    | manager ship |
    manager := NullPositionManager new.
    ship := Spaceship withName: 'Voyager'.
    ship moveTo: 3.
    manager moveShip: ship backward: 2.
    self assert: ship position equals: 1.
    self assert: manager ships isEmpty.
]

{ #category : 'tests - instance' }
NullPositionManagerTest >> testMoveShipForwardMovesShipProperly [
    | manager ship |
    manager := NullPositionManager new.
    ship := Spaceship withName: 'Enterprise'.
    manager moveShip: ship forward: 3.
    self assert: ship position equals: 3.
    self assert: manager ships isEmpty.
]

{ #category : 'tests - instance' }
NullPositionManagerTest >> testMoveShipToSetsExactPosition [
    | manager ship |
    manager := NullPositionManager new.
    ship := Spaceship withName: 'Discovery'.
    manager moveShip: ship to: 5.
    self assert: ship position equals: 5.
    self assert: manager ships isEmpty.
]

{ #category : 'tests - instance' }
NullPositionManagerTest >> testPositionOfReturnsShipPosition [
    | manager ship |
    manager := NullPositionManager new.
    ship := Spaceship withName: 'Query'.
    ship moveTo: 4.
    self assert: (manager positionOf: ship) equals: 4.
]

{ #category : 'tests - instance' }
NullPositionManagerTest >> testShipsReturnsEmpty [
    self assert: (NullPositionManager new ships) isEmpty.
]
