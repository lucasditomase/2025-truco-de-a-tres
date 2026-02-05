Class {
    #name : 'BoardNavigationTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
BoardNavigationTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

{ #category : 'helpers - board setup' }
BoardNavigationTest >> placeEffect: anEffect atPosition: position inBoard: board [
    "Helper method for semantic board state setup"
    board cells at: position put: anEffect
]

{ #category : 'helpers - board setup' }
BoardNavigationTest >> placeCells: cellArray inBoard: board [
    "Helper method to set all cells at once"
    board cells: cellArray asArray
]

{ #category : 'helpers - board setup' }
BoardNavigationTest >> createEmptyCellsOfSize: size [
    "Helper method to create empty board cells"
    ^ (1 to: size) collect: [ :i | nil ]
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testApplyEffectToDoesNothingIfNoEffect [
    | board ship cells |

    ship := Spaceship withName: 'Ship'.
    ship moveTo: 2.

    board := Board of: 5 andWormholeAt: {}.

    cells := (1 to: 5) collect: [:i | nil].
    board cells: cells asArray.
    board registerShips: { ship }.

    board applyEffectTo: ship.

    self assert: ship position equals: 2.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testApplyWormholeIfPresentReturnsExit [
    | board wormhole |

    wormhole := Wormhole from: 2 to: 7.
    board := Board of: 10 andWormholeAt: { wormhole }.

    self assert: (board applyWormholeIfPresentAt: 2) equals: 7.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testApplyWormholeIfPresentReturnsSameWhenAbsent [
    | board |

    board := Board of: 10 andWormholeAt: {}.

    self assert: (board applyWormholeIfPresentAt: 3) equals: 3.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testAtomicBombEffectResetsPositionsButKeepsLaps [
    | effect ship1 ship2 ship3 allShips board |

    effect := AtomicBombEffect new.
    board := Board of: 5 andWormholeAt: {}.

    ship1 := Spaceship withName: 'Red'.
    ship2 := Spaceship withName: 'Blue'.
    ship3 := Spaceship withName: 'Green'.

    ship1 moveTo: 6.
    ship2 moveTo: 3.
    ship3 moveTo: 9.

    ship1 lap: 1.
    ship2 lap: 2.
    ship3 lap: 3.

    allShips := {
        ship1.
        ship2.
        ship3.
    }.

    board registerShips: allShips.

    effect applyTo: ship2 inContextOf: allShips inBoard: board.

    self assert: ship1 position equals: 0.
    self assert: ship2 position equals: 0.
    self assert: ship3 position equals: 0.
    self assert: ship1 lap equals: 1.
    self assert: ship2 lap equals: 2.
    self assert: ship3 lap equals: 3.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testBlackHoleEffectMovesSpaceshipBackwards [
    | board ship |

    board := Board of: 5 andWormholeAt: #().

    ship := Spaceship withName: 'Lucas'.
    ship moveTo: 4.

    board cells at: 4 put: BlackHoleEffect new.
    board registerShips: { ship }.
    board applyEffectTo: ship.

    self assert: ship position equals: 0.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testBoardPreventsEntryToHyperGravityCellWithLowRoll [
    | dice1 board ship lappedShip effect newPosition |
    dice1 := Die withSides: 6.

    board := Board of: 5 andWormholeAt: #().

    ship := Spaceship withName: 'Lucas'.
    ship moveTo: 2.
    lappedShip := ShipStatus for: ship position: 2 laps: 0 penalized: false.

    effect := HyperGravityEffect new.
    effect requiredRoll: 4.
    board cells at: 4 put: effect.

    newPosition := board
        determineNewPositionFrom: ship position
        after: 1.

    self assert: newPosition equals: 3.
    self assert: ship position equals: 2.

    self assert: lappedShip lapCount equals: 0.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testCanEnterHyperGravityCellWithSufficientRoll [
    | board effect |
    board := Board of: 5 andWormholeAt: #().
    effect := HyperGravityEffect new.
    board cells at: 3 put: effect.

    self assert: (effect allowsEntryWithRoll: 5).
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testCannotEnterHyperGravityCellWithLowRoll [
    | board effect |
    board := Board of: 5 andWormholeAt: #().
    effect := HyperGravityEffect new.
    board cells at: 3 put: effect.

    self deny: (effect allowsEntryWithRoll: 2).
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testCardEffectAddsCardToShip [
    | board ship effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := CardEffect new.
    board cells at: 3 put: effect.
    ship := Spaceship withName: 'Player'.
    ship moveTo: 3.
    board registerShips: { ship }.
    board applyEffectTo: ship.
    self assert: ship cards size equals: 1.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testHyperGravityAllowsEntryWhenRollIsSufficient [
    | board ship effect newPosition |

    board := Board of: 5 andWormholeAt: #().

    ship := Spaceship withName: 'Lucas'.
    ship moveTo: 2.

    effect := HyperGravityEffect new.
    effect requiredRoll: 4.
    board cells: (Dictionary new).
    board cells at: 4 put: effect.
    board cells at: 3 put: NoEffect new.
    board registerShips: { ship }.

    newPosition := board determineNewPositionFrom: ship position after: 1.
    self assert: newPosition equals: 3.

    ship moveTo: newPosition.
    board applyEffectTo: ship.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testHyperGravityEffectHasCorrectDefaultRoll [
    | effect |
    effect := HyperGravityEffect new.
    self assert: effect requiredRoll equals: 4.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testHyperJumpEffectJumpsShipForward [
    | dice1 dicesGame board ship1 ship2 lappedShip1 effect newPosition game |

    dice1 := Die withSides: 6.
    dicesGame := DiceCup with: (OrderedCollection with: dice1).
    board := Board of: 10 length: 10 andWormholeAt: #().

    effect := HyperJumpEffect withValues: #(3 5 2 4).
    board cells at: 7 put: effect.

    ship1 := Spaceship withName: 'Apollo'.
    ship1 restoreFuel.
    ship2 := Spaceship withName: 'Gemini'.
    ship2 restoreFuel.

    lappedShip1 := ShipStatus for: ship1 position: 5 laps: 0 penalized: false.

    ship1 moveTo: 5.
    self assert: ship1 position equals: 5.

    newPosition := board
        determineNewPositionFrom: ship1 position
        after: 1.
    self assert: newPosition equals: 6.

    ship1 moveTo: newPosition.
    self assert: ship1 position equals: 6.

    game := Game
        startWithShips: {ship1. ship2}
        board: board
        dice: dicesGame
        laps: 1.

    effect applyTo: ship1 inBoard: board.

    self assert: ship1 position equals: 1.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testLapDoesNotIncrementWhenStayingWithinBounds [
    | board ship newPosition |

    board := Board of: 10 andWormholeAt: OrderedCollection new.

    ship := Spaceship withName: 'Lucas'.
    ship moveTo: 3.

    newPosition := board calculateNewPositionFrom: ship position after: 4 moves: ship.

    self assert: newPosition equals: 7.
    self assert: ship lap equals: 0.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testLapIncrementsWhenPassingLastCell [
    | dice1 board ship newPosition |

    dice1 := Die withSides: 6.

    board := Board of: 10 andWormholeAt: OrderedCollection new.
    ship := Spaceship withName: 'Lucas'.
    ship moveTo: 8.

    newPosition := board
        calculateNewPositionFrom: ship position
        after: 3
        moves: (ShipStatus for: ship position: 8 laps: 0 penalized: false).

    self assert: newPosition equals: 1.
    self assert:
        (ShipStatus for: ship position: 8 laps: 0 penalized: false) lapCount
            equals: 0.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testMoonWalkEffectMovesOtherSpaceshipsBackwards [
    | dice1 effect ship1 ship2 ship3 allShips board |

    dice1 := Die withSides: 6.

    effect := MoonWalkEffect new.

    ship1 := Spaceship withName: 'Player1'.
    ship2 := Spaceship withName: 'Player2'.
    ship3 := Spaceship withName: 'Player3'.

    board := Board of: 5 andWormholeAt: {}.

    ship1 moveTo: 5.
    ship2 moveTo: 7.
    ship3 moveTo: 3.

    allShips := { ship1. ship2. ship3 }.
    board registerShips: allShips.

    effect applyTo: ship2 inContextOf: allShips inBoard: board.

    self assert: ship2 position equals: 7.
    self assert: ship1 position equals: 3.
    self assert: ship3 position equals: 1.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testMoveShipBackwardWithoutManager [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Falcon'.
    ship moveTo: 4.

    board registerShips: { ship }.
    board moveShip: ship backward: 2.

    self assert: ship position equals: 2.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testMoveShipForwardWithoutManager [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Falcon'.
    ship moveTo: 1.

    board registerShips: { ship }.
    board moveShip: ship forward: 2.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testMoveShipForwardWrapsAround [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Wrap'.
    ship moveTo: 4.

    board registerShips: { ship }.
    board moveShip: ship forward: 3.

    self assert: ship position equals: 2.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testMoveShipBackwardWrapsAround [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'BackWrap'.
    ship moveTo: 1.

    board registerShips: { ship }.
    board moveShip: ship backward: 3.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testMoveShipToWithoutManager [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Falcon'.
    ship moveTo: 0.

    board registerShips: { ship }.
    board moveShip: ship to: 3.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testPositionOfWithoutManager [
    | board ship |
    board := Board of: 8 andWormholeAt: #().
    ship := Spaceship withName: 'Solo'.
    ship moveTo: 1.

    board registerShips: { ship }.
    self assert: (board positionOf: ship) equals: 1.

    board moveShip: ship to: 4.
    self assert: (board positionOf: ship) equals: 4.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testRegisterShipsAndMovesWithManager [
    | board ship1 ship2 |
    board := Board of: 10 andWormholeAt: #().
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship1 moveTo: 2.
    ship2 moveTo: 5.

    board registerShips: { ship1. ship2 }.
    self assert: (board positionOf: ship1) equals: 2.

    board moveShip: ship1 forward: 3.
    board moveShip: ship2 backward: 2.
    board moveShip: ship1 to: 7.

    self assert: (board positionOf: ship1) equals: 7.
    self assert: (board positionOf: ship2) equals: 3.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testWormholeTransportsCorrectly [
    | board |
    board := Board of: 20 andWormholeAt: (OrderedCollection withAll: {
        Wormhole from: 2 to: 10.
        Wormhole from: 10 to: 2.
    }).

    self assert: (board applyWormholeIfPresentAt: 2) equals: 10.
    self assert: (board applyWormholeIfPresentAt: 10) equals: 2.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testReverseAtReversesWormhole [
    | board |
    board := Board of: 5 andWormholeAt: { Wormhole from: 1 to: 4 }.
    board reverseAt: 1.
    self assert: (board applyWormholeIfPresentAt: 1) equals: -1.
    self assert: (board applyWormholeIfPresentAt: 4) equals: 6.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testReverseEffectAtReplacesEffect [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := BlackHoleEffect new.
    board cells at: 2 put: effect.
    board reverseEffectAt: 2.
    self assert: (board effectAt: 2) class equals: ReversedEffect.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testReverseEffectAtSkipsAtomicBomb [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := AtomicBombEffect new.
    board cells at: 3 put: effect.
    board reverseEffectAt: 3.
    self assert: (board effectAt: 3) class equals: AtomicBombEffect.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testLastMoveForTracksMovementAndCanBeCleared [
    | board ship |
    board := Board of: 5 andWormholeAt: {}.
    ship := Spaceship withName: 'Tracker'.
    ship moveTo: 1.
    board registerShips: { ship }.

    board moveShip: ship forward: 2.
    self assert: (board lastMoveFor: ship) equals: 2.

    board moveShip: ship backward: 1.
    self assert: (board lastMoveFor: ship) equals: -1.

    board moveShip: ship to: 4.
    self assert: (board lastMoveFor: ship) equals: 2.

    board clearLastMoves.
    self assert: (board lastMoveFor: ship) equals: 0.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testRecordMovesDuringCapturesStartAndAggregatedDelta [
    | board ship report data |
    board := Board of: 5 andWormholeAt: {}.
    ship := Spaceship withName: 'Tracker'.
    ship moveTo: 1.
    board registerShips: { ship }.

    report := board recordMovesDuring: [
        board moveShip: ship forward: 7.
        board moveShip: ship backward: 2
    ].
    data := report at: ship ifAbsent: [ self fail: 'Expected move data' ].

    self assert: data startPosition equals: 1.
    self assert: data delta equals: 5.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testWithMovementTrackingDuringKeepsSingleRecordingSession [
    | board ship report data |
    board := Board of: 5 andWormholeAt: {}.
    ship := Spaceship withName: 'Scout'.
    ship moveTo: 0.
    board registerShips: { ship }.

    report := board withMovementTrackingDuring: [
        self assert: board isRecordingMoves.
        board moveShip: ship forward: 1.
        board withMovementTrackingDuring: [
            self assert: board isRecordingMoves.
            board moveShip: ship forward: 1.
        ]
    ].
    data := report at: ship ifAbsent: [ self fail: 'Expected move data' ].

    self deny: board isRecordingMoves.
    self assert: ship position equals: 2.
    self assert: data delta equals: 2.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testDetermineNewPositionAppliesWormholeWhenNoSteps [
    | board wormhole |
    wormhole := Wormhole from: 1 to: 4.
    board := Board of: 5 andWormholeAt: { wormhole }.

    self assert: (board determineNewPositionFrom: 1 after: 0 withRoll: 0) equals: 4.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testDetermineNewPositionBackwardIgnoresHyperGravity [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := HyperGravityEffect new.
    board cells at: 2 put: effect.

    self assert: (board determineNewPositionFrom: 2 after: -1 withRoll: 1) equals: 1.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testDrawCardReturnsACard [
    | board card |
    board := Board of: 5 andWormholeAt: {}.
    card := board drawCard.

    self assert: (Card withAllSubclasses includes: card class).
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testDrawCardUsesInjectedDealer [
    | board dealerCard dealerCalled |
    board := Board of: 5 andWormholeAt: {}.
    dealerCard := NullCard new.
    dealerCalled := false.

    board useCardDealer: [
        dealerCalled := true.
        dealerCard
    ].

    self assert: board drawCard equals: dealerCard.
    self assert: dealerCalled.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testUseCardDealerCyclingThroughReturnsCardsInSequence [
    | board |
    board := Board of: 5 andWormholeAt: {}.

    board useCardDealerCyclingThrough: { AdvanceCard. ShieldCard }.

    self assert: board drawCard class equals: AdvanceCard.
    self assert: board drawCard class equals: ShieldCard.
    self assert: board drawCard class equals: AdvanceCard.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testUseCardDealerRequiresCallableObject [
    | board |
    board := Board of: 5 andWormholeAt: {}.

    self
        should: [ board useCardDealer: Object new ]
        raise: Error
        withMessageText: 'Card dealer must respond to #value'.
]
