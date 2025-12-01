Class {
    #name : 'ShipMover',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'moving' }
ShipMover class >> move: aShip backward: steps [
    aShip moveBack: steps.
]

{ #category : 'moving' }
ShipMover class >> move: aShip forward: steps [
    aShip moveForward: steps.
]

{ #category : 'moving' }
ShipMover class >> move: aShip to: aPosition [
    aShip moveTo: aPosition.
]
