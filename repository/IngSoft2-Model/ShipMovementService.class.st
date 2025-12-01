Class {
    #name : 'ShipMovementService',
    #superclass : 'Object',
    #instVars : [
        'positionManager',
        'cellCount',
        'lastMoves',
        'recentMoves'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
ShipMovementService class >> withPositionManager: aManager cellCount: aCount lastMoves: aDictionary [
    ^ self new
        initializeWithPositionManager: aManager
        cellCount: aCount
        lastMoves: aDictionary
]

{ #category : 'initialization' }
ShipMovementService >> initializeWithPositionManager: aManager cellCount: aCount lastMoves: aDictionary [
    positionManager := aManager.
    cellCount := aCount.
    lastMoves := aDictionary.
    recentMoves := nil.
    ^ self
]

{ #category : 'configuration' }
ShipMovementService >> positionManager: aManager [
    positionManager := aManager
]

{ #category : 'configuration' }
ShipMovementService >> cellCount: aCount [
    cellCount := aCount
]

{ #category : 'configuration' }
ShipMovementService >> lastMoves: aDictionary [
    lastMoves := aDictionary
]

{ #category : 'movement' }
ShipMovementService >> moveShip: aShip backward: steps [
    | oldPos |
    oldPos := positionManager positionOf: aShip.
    ^ self
        moveShip: aShip
        from: oldPos
        toPosition: oldPos - steps
        delta: [ :new :previous | steps negated ]
]

{ #category : 'movement' }
ShipMovementService >> moveShip: aShip forward: steps [
    | oldPos |
    oldPos := positionManager positionOf: aShip.
    ^ self
        moveShip: aShip
        from: oldPos
        toPosition: oldPos + steps
        delta: [ :new :previous | steps ]
]

{ #category : 'movement' }
ShipMovementService >> moveShip: aShip to: aPosition [
    | oldPos |
    oldPos := positionManager positionOf: aShip.
    ^ self
        moveShip: aShip
        from: oldPos
        toPosition: aPosition
        delta: [ :new :previous | new - previous ]
]

{ #category : 'movement' }
ShipMovementService >> moveShip: aShip from: oldPos toPosition: target delta: deltaBlock [
    | newPos delta |
    cellCount = 0 ifTrue: [ ^ 0 ].
    newPos := target \\ cellCount.
    positionManager moveShip: aShip to: newPos.
    delta := deltaBlock value: newPos value: oldPos.
    lastMoves at: aShip put: delta.
    self recordRecentMoveFor: aShip startingAt: oldPos delta: delta.
    ^ delta
]

{ #category : 'movement' }
ShipMovementService >> clearLastMoves [
    lastMoves removeAll.
    recentMoves ifNotNil: [ recentMoves removeAll ]
]

{ #category : 'movement' }
ShipMovementService >> lastMoveFor: aShip [
    ^ lastMoves at: aShip ifAbsent: [ 0 ]
]

{ #category : 'movement' }
ShipMovementService >> recentMovesDuring: aBlock [
    | previous captured |
    previous := recentMoves.
    captured := Dictionary new.
    recentMoves := Dictionary new.
    [ aBlock value. captured := recentMoves copy ] ensure: [
        recentMoves := previous.
        captured ifNil: [ captured := Dictionary new ]
    ].
    ^ captured
]

{ #category : 'movement' }
ShipMovementService >> recordRecentMoveFor: aShip startingAt: startPosition delta: delta [
    | record start total |
    recentMoves ifNil: [ ^ self ].
    record := recentMoves at: aShip ifAbsent: [ Array with: startPosition with: 0 ].
    start := record first.
    total := record second + delta.
    recentMoves at: aShip put: (Array with: start with: total)
]
