Class {
    #name : 'TurnData',
    #superclass : 'Object',
    #instVars : [
        'lastSteps',
        'lastPreviousPosition',
        'lastCardPlayed',
        'lastEffectiveCard',
        'fuelHistory',
        'lastEffectWasCard'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
TurnData >> initialize [
    lastSteps := 0.
    lastPreviousPosition := 0.
    lastCardPlayed := NullCard new.
    lastEffectiveCard := NullCard new.
    fuelHistory := Dictionary new.
    lastEffectWasCard := false.
    ^ self
]

{ #category : 'initialization' }
TurnData >> initializeFuelHistoryForShips: someShips [
    someShips do: [ :ship |
        fuelHistory at: ship put: (OrderedCollection with: ship fuel) ]
]

{ #category : 'process actions' }
TurnData >> recordFuelFor: aShip [
    | history |
    history := fuelHistory at: aShip ifAbsentPut: [ OrderedCollection new ].
    history addLast: aShip fuel.
    history size > 3 ifTrue: [ history removeFirst ]
]

{ #category : 'accessing' }
TurnData >> fuelHistoryFor: aShip [
    ^ fuelHistory at: aShip ifAbsent: [ OrderedCollection new ]
]

{ #category : 'accessing' }
TurnData >> fuelHistory: aDictionary [
    fuelHistory := aDictionary
]

{ #category : 'accessing' }
TurnData >> lastSteps [
    ^ lastSteps
]

{ #category : 'accessing' }
TurnData >> lastSteps: aNumber [
    lastSteps := aNumber
]

{ #category : 'accessing' }
TurnData >> lastPreviousPosition [
    ^ lastPreviousPosition
]

{ #category : 'accessing' }
TurnData >> lastPreviousPosition: aNumber [
    lastPreviousPosition := aNumber
]

{ #category : 'accessing' }
TurnData >> lastCardPlayed [
    ^ lastCardPlayed
]

{ #category : 'accessing' }
TurnData >> lastCardPlayed: aCard [
    lastCardPlayed := aCard.
    (aCard class = RedoCard or: [ aCard class = RepeatCard ]) ifTrue: [ ^ self ].
    lastEffectWasCard := true.
    lastEffectiveCard := aCard
]

{ #category : 'accessing' }
TurnData >> lastEffectWasCard [
    ^ lastEffectWasCard
]

{ #category : 'accessing' }
TurnData >> lastEffectWasCard: aBoolean [
    lastEffectWasCard := aBoolean
]

{ #category : 'accessing' }
TurnData >> lastEffectiveCard [
    ^ lastEffectiveCard
]

{ #category : 'accessing' }
TurnData >> lastEffectiveCard: aCard [
    lastEffectiveCard := aCard
]
