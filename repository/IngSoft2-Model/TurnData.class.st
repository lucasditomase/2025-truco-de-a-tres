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
    super initialize.
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

{ #category : 'documentation' }
TurnData >> fuelHistorySemantics [
    "Returns a short explanation of the `fuelHistory` ordering semantics.

    The implementation stores recent fuel snapshots in an OrderedCollection
    where new samples are added to the end. When the collection is trimmed to
    three entries the `first` element corresponds to the antepenultimate
    recorded value used by Time Machine logic."
    ^ 'fuelHistory: oldest..newest; first is antepenultimate when size=3.'
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
    aCard recordsLastEffect ifFalse: [ ^ self ].
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
{ #category : 'accessing' }
TurnData >> hasHistoryForTimeMachine: aShip [
    ^ (self fuelHistoryFor: aShip) size >= 2
]

{ #category : 'accessing' }
TurnData >> antepenultimateFuelFor: aShip [
    ^ (self fuelHistoryFor: aShip) first
]
{ #category : 'accessing' }
TurnData >> fuelAtStartOfPenultimateTurnFor: aShip [
    "Returns the fuel value at the start of the penultimate turn (antepenultimate snapshot).
    Semantics: fuelHistory stores start-of-turn snapshots in order oldest → newest.
    When size >= 2, `first` is the antepenultimate (the start of two turns ago).
    Raises an error if insufficient history (< 2 entries)."
    | history |
    history := self fuelHistoryFor: aShip.
    history size < 2
        ifTrue: [ self error: 'Insufficient fuel history for Time Machine' ].
    ^ history first
]