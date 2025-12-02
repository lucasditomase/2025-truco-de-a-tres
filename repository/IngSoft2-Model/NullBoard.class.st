Class {
    #name : 'NullBoard',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'spaceships' }
NullBoard >> moveShip: aShip backward: steps [
    ShipMover move: aShip backward: steps.
]

{ #category : 'spaceships' }
NullBoard >> moveShip: aShip forward: steps [
    ShipMover move: aShip forward: steps.
]

{ #category : 'spaceships' }
NullBoard >> moveShip: aShip to: aPosition [
    ShipMover move: aShip to: aPosition.
]
