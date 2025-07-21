Class {
    #name : 'Board',
    #superclass : 'Object',
    #instVars : [
        'cellCount',
        'wormholes',
        'cells',
        'totalLengthInParsecs',
        'positionManager',
        'lastMoves'
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
    (effect respondsTo: #applyTo:inContextOf:inBoard:)
        ifTrue: [ effect applyTo: aSpaceship inContextOf: self ships inBoard: self ]
        ifFalse: [ effect applyTo: aSpaceship inBoard: self ].
]

{ #category : 'initialize' }
Board >> applyWormholeIfPresentAt: aPosition [
    | wormhole |
    wormhole := wormholes detect: [ :w | w hasEntryAt: aPosition ] ifNone: [ NullWormhole new ].
    ^ wormhole exitFrom: aPosition inBoard: self
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
    ^ cells size.
]

{ #category : 'initialize' }
Board >> cells [
    ^ cells.
]

{ #category : 'initialize' }
Board >> cells: aCollection [
    cells := aCollection
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
            (effect respondsTo: #allowsEntryWithRoll:)
                ifTrue: [
                    (effect allowsEntryWithRoll: aRoll)
                        ifFalse: [ ^ self applyWormholeIfPresentAt: pos ]
                ].
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
    effect := cells at: aPosition ifAbsent: [ NullEffect new ].
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

    0 to: aCount - 1 do: [ :i |
        cells at: i put: NoEffect new ].

    ^ self
]

{ #category : 'initialize' }
Board >> initializeWithCells: aCount length: aLengthInParsecs andWormholes: aCollection randomizeEffects: aBoolean [
    self
        initializeWithCells: aCount
        length: aLengthInParsecs
        andWormholes: aCollection.

    aBoolean ifTrue: [ self populateRandomEffects ].

    ^ self
]

{ #category : 'initialize' }
Board >> isPositionReachedAt: aPosition [
    ^ aPosition >= cellCount.
]

{ #category : 'spaceships' }
Board >> moveShip: aShip backward: steps [
    | oldPos newPos |
    oldPos := self positionOf: aShip.
    newPos := (oldPos - steps) \\ cellCount.
    positionManager moveShip: aShip to: newPos.
    lastMoves at: aShip put: steps negated.
    ^ steps negated
]

{ #category : 'spaceships' }
Board >> moveShip: aShip forward: steps [
    | oldPos newPos |
    oldPos := self positionOf: aShip.
    newPos := (oldPos + steps) \\ cellCount.
    positionManager moveShip: aShip to: newPos.
    lastMoves at: aShip put: steps.
    ^ steps
]

{ #category : 'spaceships' }
Board >> moveShip: aShip to: aPosition [
    | oldPos diff newPos |
    oldPos := self positionOf: aShip.
    newPos := aPosition \\ cellCount.
    positionManager moveShip: aShip to: newPos.
    diff := newPos - oldPos.
    lastMoves at: aShip put: diff.
    ^ diff
]

{ #category : 'spaceships' }
Board >> positionOf: aShip [
    ^ positionManager positionOf: aShip
]

{ #category : 'spaceships' }
Board >> clearLastMoves [
    lastMoves := Dictionary new
]

{ #category : 'spaceships' }
Board >> lastMoveFor: aShip [
    ^ lastMoves at: aShip ifAbsent: [ 0 ]
]

{ #category : 'initialize' }
Board >> randomEffect [
    | randomNumber |
    randomNumber := (1 to: 100) atRandom.
    randomNumber <= 40 ifTrue: [ ^ NoEffect new ].
    randomNumber <= 60 ifTrue: [ ^ BlackHoleEffect new ].
    randomNumber <= 80 ifTrue: [ ^ HyperGravityEffect new ].
    randomNumber <= 90 ifTrue: [ ^ MoonWalkEffect new ].
    randomNumber <= 98 ifTrue: [ ^ HyperJumpEffect withValues: #(1 2 3) ].
    ^ AtomicBombEffect new
]

{ #category : 'initialize' }
Board >> populateRandomEffects [
    0 to: cellCount - 1 do: [ :i |
        cells at: i put: self randomEffect ].

    ^ self
]

{ #category : 'spaceships' }
Board >> registerShips: someShips [
        positionManager := PositionManager forShips: someShips
]

{ #category : 'spaceships' }
Board >> ships [
    ^ positionManager ships
]

{ #category : 'effects' }
Board >> reverseAt: aPosition [
    | wormhole |
    wormhole := wormholes detect: [ :w | (w entry = aPosition) or: [ w exit = aPosition ] ] ifNone: [ NullWormhole new ].
    wormhole reverseOnBoard: self at: aPosition
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

{ #category : 'validation' }
Board >> validateAsBoard [
    ^ self
]
