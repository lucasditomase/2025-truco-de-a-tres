Class {
    #name : 'Board',
    #superclass : 'Object',
    #instVars : [
        'cellCount',
        'wormholes',
        'cells',
        'totalLengthInParsecs',
        'positionManager',
        'lastMoves',
        'movementService'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialize' }
Board class >> convertToParsecs: aLength [
    ^ [ aLength asParsecs ]
        on: MessageNotUnderstood
        do: [ aLength ]
]

{ #category : 'effects' }
Board class >> effectDistributionWeights [
    ^ {
        [ NoEffect new ] -> 38.
        [ CardEffect new ] -> 10.
        [ BlackHoleEffect new ] -> 20.
        [ HyperGravityEffect new ] -> 20.
        [ MoonWalkEffect new ] -> 10.
        [ HyperJumpEffect withValues: #(1 2 3) ] -> 8.
        [ AtomicBombEffect new ] -> 2
    }
]

{ #category : 'initialize' }
Board class >> of: anAmountOfCells andWormholeAt: positions [
    self validateCellCount: anAmountOfCells.
    self validateWormholes: positions.
    ^ self new
        initializeWithCells: anAmountOfCells
        andWormholes: positions
]

{ #category : 'initialize' }
Board class >> of: anAmountOfCells length: parsecLength andWormholeAt: positions [
    | lengthOnParsecs |
    self validateCellCount: anAmountOfCells.
    self validateWormholes: positions.
    lengthOnParsecs := self convertToParsecs: parsecLength.

    ^ self new
        initializeWithCells: anAmountOfCells
        length: lengthOnParsecs
        andWormholes: positions
]

{ #category : 'initialize' }
Board class >> of: anAmountOfCells length: parsecLength lengthLightYears: lightYears andWormholeAt: positions [
    self
        validateLengthConsistencyBetweenParsecs: parsecLength
        andLightYears: lightYears.
    self validateCellCount: anAmountOfCells.
    self validateWormholes: positions.

    ^ self
        of: anAmountOfCells
        length: parsecLength
        andWormholeAt: positions
]

{ #category : 'initialize' }
Board class >> of: anAmountOfCells lengthLightYears: lightYears andWormholeAt: positions [
    self validateCellCount: anAmountOfCells.
    self validateWormholes: positions.

    ^ self
        of: anAmountOfCells
        length: (Distance lightYears: lightYears) asParsecs
        andWormholeAt: positions
]

{ #category : 'initialize' }
Board class >> of: anAmountOfCells andWormholeAt: positions withRandomEffects: aBoolean [
    | board |
    board := self
        of: anAmountOfCells
        andWormholeAt: positions.
    aBoolean ifTrue: [ board populateRandomEffects ].
    ^ board
]

{ #category : 'initialize' }
Board class >> validateCellCount: aCount [
    (aCount isInteger and: [ aCount > 0 ]) ifFalse: [
        self error: 'Board must have a positive number of cells' ]
]

{ #category : 'initialize' }
Board class >> validateLengthConsistencyBetweenParsecs: parsecLength andLightYears: lightYears [
    (Distance parsecs: parsecLength) asLightYears = lightYears ifFalse: [
        self error: 'Length mismatch between parsecs and light years'
    ]
]

{ #category : 'initialize' }
Board class >> validateWormholes: aCollection [
    (aCollection isCollection and: [
        aCollection allSatisfy: [ :each | each isValid ] ]) ifFalse: [
        self error: 'All wormholes must be valid objects' ]
]

{ #category : 'initialize' }
Board >> applyEffectTo: aSpaceship [
    | effect |

    effect := self effectAt: (self positionOf: aSpaceship).
    effect applyTo: aSpaceship inContextOf: self ships inBoard: self
]

{ #category : 'initialize' }
Board >> applyWormholeIfPresentAt: aPosition [
    ^ (self wormholeEnteringAt: aPosition) exitFrom: aPosition inBoard: self
]

{ #category : 'initialize' }
Board >> calculateNewPositionFrom: current after: steps moves: aShipStatus [
    | newPosition |

    newPosition := (current + steps) \\ cellCount.

    (newPosition <= current) ifTrue: [ aShipStatus addLap ].

    ^ newPosition.
]

{ #category : 'initialize' }
Board >> cellCount [
    ^ cellCount
]

{ #category : 'initialize' }
Board >> cells [
    ^ cells.
]

{ #category : 'initialize' }
Board >> cells: aCollection [
    cells := aCollection.
    cells size > 0 ifTrue: [
        cellCount := cells size.
        movementService ifNotNil: [ movementService cellCount: cellCount ]
    ]
]

{ #category : 'moves' }
Board >> determineNewPositionFrom: aPosition after: steps [
    ^ self
        determineNewPositionFrom: aPosition
        after: steps
        withRoll: steps abs
]

{ #category : 'moves' }
Board >> determineNewPositionFrom: aPosition after: steps withRoll: aRoll [
    | pos direction effect |
    steps = 0 ifTrue: [ ^ self applyWormholeIfPresentAt: aPosition ].
    pos := aPosition.
    direction := steps >= 0 ifTrue: [ 1 ] ifFalse: [ -1 ].

    1 to: steps abs do: [ :i |
        pos := (pos + direction) \\ cellCount.
        direction > 0 ifTrue: [
            effect := self effectAt: pos.
            (effect allowsEntryWithRoll: aRoll)
                ifFalse: [ ^ self applyWormholeIfPresentAt: pos ].
        ].
    ].
    ^ self applyWormholeIfPresentAt: pos
]

{ #category : 'deck' }
Board >> drawCard [
    ^ CardDeck randomCard
]

{ #category : 'initialize' }
Board >> effectAt: aPosition [
    | effect |
    effect := cells at: aPosition ifAbsent: [ ^ NullEffect new ].
    ^ effect ifNil: [ NullEffect new ]
]

{ #category : 'initialize' }
Board >> initializeWithCells: aCount andWormholes: aCollection [
    ^ self
        initializeWithCells: aCount
        length: aCount
        andWormholes: aCollection
]

{ #category : 'initialize' }
Board >> initializeWithCells: aCount length: aLengthInParsecs andWormholes: aCollection [
    cellCount := aCount.
    totalLengthInParsecs := aLengthInParsecs.
    wormholes := aCollection asOrderedCollection.
    cells := Dictionary new.
    positionManager := NullPositionManager new.
    lastMoves := Dictionary new.
    self initializeMovementService.

    0 to: aCount - 1 do: [ :i |
        cells at: i put: NoEffect new ].

    ^ self
]

{ #category : 'initialize' }
Board >> initializeMovementService [
    movementService := ShipMovementService
        withPositionManager: positionManager
        cellCount: (cellCount max: 1)
        lastMoves: lastMoves
]

{ #category : 'spaceships' }
Board >> moveShip: aShip backward: steps [
    | start target |
    ^ OrderedCollection withAll: self effectDistributionWeights

{ #category : 'spaceships' }
Board >> moveShip: aShip forward: steps [
    | start target |
    start := self positionOf: aShip.
    target := self determineNewPositionFrom: start after: steps.
    ^ movementService
        moveShip: aShip
        from: start
        toPosition: target
        delta: [ :new :previous | steps ]
]

{ #category : 'spaceships' }
Board >> moveShip: aShip to: aPosition [
    | start |
    start := self positionOf: aShip.
    ^ movementService
        moveShip: aShip
        from: start
        toPosition: aPosition
        delta: [ :new :previous | new - previous ]
]

{ #category : 'spaceships' }
Board >> positionOf: aShip [
    ^ positionManager positionOf: aShip
]

{ #category : 'spaceships' }
Board >> clearLastMoves [
    movementService clearLastMoves
]

{ #category : 'spaceships' }
Board >> lastMoveFor: aShip [
    ^ movementService lastMoveFor: aShip
]

{ #category : 'spaceships' }
Board >> isRecordingMoves [
    ^ movementService isRecordingMoves
]

{ #category : 'spaceships' }
Board >> withMovementTrackingDuring: aBlock [
    self isRecordingMoves ifTrue: [ ^ aBlock value ].
    ^ self recordMovesDuring: aBlock
]

{ #category : 'spaceships' }
Board >> recordMovesDuring: aBlock [
    ^ movementService recentMovesDuring: aBlock
]

{ #category : 'initialize' }
Board >> populateRandomEffects [
    0 to: cellCount - 1 do: [ :i |
        cells at: i put: self randomEffect ].

    ^ self
]

{ #category : 'spaceships' }
Board >> registerShips: someShips [
    positionManager := PositionManager forShips: someShips.
    movementService positionManager: positionManager.
]

{ #category : 'spaceships' }
Board >> ships [
    ^ positionManager ships
]

{ #category : 'effects' }
Board >> reverseAt: aPosition [
    (self wormholeTouching: aPosition) reverseOnBoard: self at: aPosition
]

{ #category : 'effects' }
Board >> reverseEffectAt: aPosition [
    | effect |
    effect := self effectAt: aPosition.
    effect class = AtomicBombEffect ifTrue: [ ^ self ].
    cells at: aPosition put: effect reversed
]

{ #category : 'effects' }
Board >> addWormhole: aWormhole [
    wormholes add: aWormhole
]

{ #category : 'effects' }
Board >> removeWormhole: aWormhole [
    wormholes remove: aWormhole
]

{ #category : 'effects' }
Board >> randomEffect [
    ^ self randomEffectForRoll: (1 to: self totalEffectWeight) atRandom
]

{ #category : 'effects' }
Board >> randomEffectDistribution [
    ^ OrderedCollection new
        addAll: self class effectDistributionWeights;
        yourself
]

{ #category : 'effects' }
Board >> randomEffectForRoll: aNumber [
    | cumulative |
    cumulative := 0.
    self randomEffectDistribution do: [ :entry |
        cumulative := cumulative + entry value.
        aNumber <= cumulative ifTrue: [ ^ entry key value ].
    ].
    ^ AtomicBombEffect new
]

{ #category : 'effects' }
Board >> configureHyperGravityRequirementsWithMaxRoll: maxRoll [
    | safeMax |
    safeMax := (maxRoll isInteger and: [ maxRoll > 0 ]) ifTrue: [ maxRoll ] ifFalse: [ 6 ].
    cells values do: [ :effect |
        effect class = HyperGravityEffect ifTrue: [
            effect requiredRoll: safeMax
        ]
    ]
]

{ #category : 'effects' }
Board >> totalEffectWeight [
    ^ self randomEffectDistribution sum: [ :entry | entry value ]
]

{ #category : 'initialize' }
Board >> stepsFromDistance: aDistance [
    ^ self stepsFromParsecs: aDistance asParsecs
]

{ #category : 'initialize' }
Board >> stepsFromLightYears: someLightYears [
    ^ self stepsFromParsecs:
        (Distance lightYears: someLightYears) asParsecs
]

{ #category : 'initialize' }
Board >> stepsFromParsecs: someParsecs [
    | ratio |
    ratio := someParsecs / totalLengthInParsecs.

    ^ (ratio * cellCount) rounded
]

{ #category : 'accessing' }
Board >> totalLengthInParsecs [
    ^ totalLengthInParsecs
]

{ #category : 'effects' }
Board >> wormholeEnteringAt: aPosition [
    ^ wormholes detect: [ :w | w hasEntryAt: aPosition ] ifNone: [ NullWormhole new ]
]

{ #category : 'effects' }
Board >> wormholeTouching: aPosition [
    ^ wormholes detect: [ :w | (w entry = aPosition) or: [ w exit = aPosition ] ] ifNone: [ NullWormhole new ]
]
