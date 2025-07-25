Class {
    #name : 'PositionManager',
    #superclass : 'Object',
    #instVars : [
        'positions'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
PositionManager class >> forShips: someShips [
    self validateShips: someShips.

    ^ self new initializeForShips: someShips
]

{ #category : 'initialization' }
PositionManager class >> validateShips: someShips [
    (someShips isCollection) ifFalse: [
        ^ self error: 'Ships must be a collection of Spaceship instances' ].
    [ someShips do: [ :each | each validateAsSpaceship ] ]
        on: MessageNotUnderstood
        do: [ self error: 'Ships must be a collection of Spaceship instances' ]
]

{ #category : 'initialization' }
PositionManager >> initializeForShips: someShips [
    positions := Dictionary new.
    someShips do: [ :ship | positions at: ship put: ship position ].
    ^ self
]

{ #category : 'updating' }
PositionManager >> moveShip: aShip backward: steps [
    | newPos |
    newPos := (self positionOf: aShip) - steps max: 0.
    self moveShip: aShip to: newPos
]

{ #category : 'updating' }
PositionManager >> moveShip: aShip forward: steps [
    self moveShip: aShip to: (self positionOf: aShip) + steps
]

{ #category : 'updating' }
PositionManager >> moveShip: aShip to: aPosition [
    positions at: aShip put: aPosition.
    aShip moveTo: aPosition
]

{ #category : 'accessing' }
PositionManager >> positionOf: aShip [
    ^ positions at: aShip
]

{ #category : 'accessing' }
PositionManager >> ships [
    ^ positions keys
]
