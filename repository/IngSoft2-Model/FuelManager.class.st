Class {
    #name : 'FuelManager',
    #superclass : 'Object',
    #instVars : [
        'board',
        'penaltyAction'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
FuelManager class >> forBoard: aBoard penalizeWith: aBlock [
    ^ self new initializeForBoard: aBoard penalizeWith: aBlock
]

{ #category : 'initialization' }
FuelManager >> initializeForBoard: aBoard penalizeWith: aBlock [
    board := aBoard.
    penaltyAction := aBlock.
    ^ self
]

{ #category : 'actions' }
FuelManager >> consumeMovement: steps forShip: aShip [
    steps = 0 ifTrue: [ ^ self ].
    self consumeFuel: steps abs forShip: aShip
]

{ #category : 'actions' }
FuelManager >> consumeFuel: amount forShip: aShip [
    | initialFuel deficit allies ally |
    initialFuel := aShip fuel.
    aShip decreaseFuelBy: amount.
    initialFuel < amount ifFalse: [ ^ self ].

    deficit := amount - initialFuel.
    allies := aShip allies.
    allies isEmpty ifTrue: [ ^ self penalizeForNoFuel: aShip ].

    ally := allies first.
    ally decreaseFuelBy: deficit.
    self penalizeIfDepleted: ally.
    self penalizeIfDepleted: aShip.
]

{ #category : 'actions' }
FuelManager >> penalizeIfDepleted: aShip [
    aShip fuel > 0 ifTrue: [ ^ self ].
    self applyPenaltyTo: aShip
]

{ #category : 'actions' }
FuelManager >> penalizeForNoFuel: aShip [
    self applyPenaltyTo: aShip
]

{ #category : 'private' }
FuelManager >> applyPenaltyTo: aShip [
    board moveShip: aShip to: 0.
    penaltyAction value: aShip value: GameRules fuelExhaustionPenaltyTurns
]
