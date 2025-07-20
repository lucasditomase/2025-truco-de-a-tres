Class {
    #name : 'NullPositionManager',
    #superclass : 'PositionManager',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
NullPositionManager >> initialize [
    positions := Dictionary new.
    ^ self
]

{ #category : 'updating' }
NullPositionManager >> moveShip: aShip backward: steps [
    aShip moveBack: steps.
]

{ #category : 'updating' }
NullPositionManager >> moveShip: aShip forward: steps [
    aShip moveForward: steps.
]

{ #category : 'updating' }
NullPositionManager >> moveShip: aShip to: aPosition [
    aShip moveTo: aPosition.
]

{ #category : 'accessing' }
NullPositionManager >> positionOf: aShip [
    ^ aShip position
]

{ #category : 'accessing' }
NullPositionManager >> ships [
    ^ #()
]
