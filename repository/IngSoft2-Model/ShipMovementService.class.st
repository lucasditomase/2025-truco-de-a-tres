Class {
    #name : 'ShipMovementService',
    #superclass : 'Object',
    #instVars : [
        'positionManager',
        'cellCount',
        'lastMoves',
        'recentMoves',
        'recordingMoves'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
ShipMovementService class >> withPositionManager: aManager cellCount: aCount lastMoves: aDictionary [
    ^ self new
        initializeWithPositionManager: (self ensurePositionManagerFrom: aManager)
        cellCount: (self ensureCellCountFrom: aCount)
        lastMoves: (self ensureLastMovesFrom: aDictionary)
]

{ #category : 'validation' }
ShipMovementService class >> ensureCellCountFrom: aCount [
    (aCount isInteger and: [ aCount >= 0 ]) ifFalse: [
        self error: 'Cell count must be a non-negative integer'
    ].
    ^ aCount
]

{ #category : 'validation' }
ShipMovementService class >> ensureLastMovesFrom: aDictionary [
    ^ aDictionary asMovementHistoryDictionaryWithMessage: self invalidLastMovesMessage
]

{ #category : 'validation' }
ShipMovementService class >> ensurePositionManagerFrom: aManager [
    ^ aManager asPositionManagerWithMessage: self invalidPositionManagerMessage
]

{ #category : 'validation' }
ShipMovementService class >> invalidLastMovesMessage [
    ^ 'Last moves must be stored in a Dictionary'
]

{ #category : 'validation' }
ShipMovementService class >> invalidPositionManagerMessage [
    ^ 'Position manager must be an instance of PositionManager'
]

{ #category : 'initialization' }
ShipMovementService >> initializeWithPositionManager: aManager cellCount: aCount lastMoves: aDictionary [
    positionManager := self class ensurePositionManagerFrom: aManager.
    cellCount := self class ensureCellCountFrom: aCount.
    lastMoves := self class ensureLastMovesFrom: aDictionary.
    recentMoves := Dictionary new.
    recordingMoves := false.
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
    recentMoves removeAll
]

{ #category : 'movement' }
ShipMovementService >> lastMoveFor: aShip [
    ^ lastMoves at: aShip ifAbsent: [ 0 ]
]

{ #category : 'movement' }
ShipMovementService >> recentMovesDuring: aBlock [
    | previousMoves previousRecording captured |
    previousMoves := recentMoves.
    previousRecording := recordingMoves.
    captured := Dictionary new.
    recentMoves := Dictionary new.
    recordingMoves := true.
    [
        aBlock value.
        recentMoves keysAndValuesDo: [ :ship :report |
            captured at: ship put: report copy ]
    ] ensure: [
        recordingMoves := previousRecording.
        recentMoves := previousMoves
    ].
    ^ captured
]

{ #category : 'movement' }
ShipMovementService >> isRecordingMoves [
    ^ recordingMoves
]

{ #category : 'movement' }
ShipMovementService >> recordRecentMoveFor: aShip startingAt: startPosition delta: delta [
    | report |
    recordingMoves ifFalse: [ ^ self ].
    report := recentMoves
        at: aShip
        ifAbsentPut: [ MovementReport startingAt: startPosition delta: 0 ].
    report addDelta: delta
]
