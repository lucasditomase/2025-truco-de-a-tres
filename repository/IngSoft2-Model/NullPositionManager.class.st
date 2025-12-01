Class {
    #name : 'NullPositionManager',
    #superclass : 'PositionManager',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'updating' }
NullPositionManager >> moveShip: aShip backward: steps [
    ShipMover move: aShip backward: steps.
]

{ #category : 'updating' }
NullPositionManager >> moveShip: aShip forward: steps [
    ShipMover move: aShip forward: steps.
]

{ #category : 'updating' }
NullPositionManager >> moveShip: aShip to: aPosition [
    ShipMover move: aShip to: aPosition.
]

{ #category : 'accessing' }
NullPositionManager >> positionOf: aShip [
    ^ aShip position
]

{ #category : 'accessing' }
NullPositionManager >> ships [
    ^ #()
]
