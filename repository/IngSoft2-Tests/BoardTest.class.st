Class {
    #name : 'BoardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
BoardTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests - instance' }
BoardTest >> testApplyEffectToDoesNothingIfNoEffect [
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
BoardTest >> testApplyWormholeIfPresentReturnsExit [
    | board wormhole |

    wormhole := Wormhole from: 2 to: 7.
    board := Board of: 10 andWormholeAt: { wormhole }.

    self assert: (board applyWormholeIfPresentAt: 2) equals: 7.
]

{ #category : 'tests - instance' }
BoardTest >> testApplyWormholeIfPresentReturnsSameWhenAbsent [
    | board |

    board := Board of: 10 andWormholeAt: {}.

    self assert: (board applyWormholeIfPresentAt: 3) equals: 3.
]

{ #category : 'tests - instance' }
BoardTest >> testAtomicBombEffectResetsPositionsButKeepsLaps [
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
BoardTest >> testBlackHoleEffectMovesSpaceshipBackwards [
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
BoardTest >> testBoardCellCountIsCorrect [
    | board size |

    size := 7.
    board := Board of: size andWormholeAt: #().

    self assert: board cellCount equals: size.
]

{ #category : 'tests - instance' }
BoardTest >> testBoardCellsContainRecognizedEffects [
    | board validClasses |

    validClasses := { NoEffect. BlackHoleEffect. HyperGravityEffect.
        MoonWalkEffect. HyperJumpEffect. AtomicBombEffect }.

    board := Board of: 20 andWormholeAt: OrderedCollection new.

    self assert: (board cells values allSatisfy: [:e |
        validClasses anySatisfy: [:c | e class = c ] ]).
]

{ #category : 'tests - instance' }
BoardTest >> testBoardCreationWithDistanceParsecLength [
    | board |
    board := Board of: 10 length: (Distance parsecs: 12) andWormholeAt: #().

    self assert: (board stepsFromParsecs: 3) equals: 3.
]

{ #category : 'tests - instance' }
BoardTest >> testBoardCreationWithLightYearLength [
    | board |
    board := Board of: 10 lengthLightYears: 30 andWormholeAt: #().

    self assert: (board stepsFromLightYears: 6) equals: (board stepsFromParsecs: 2).
]

{ #category : 'tests - instance' }
BoardTest >> testBoardCreationWithParsecsAndLightYears [
    | board |
    board := Board of: 10 length: 10 lengthLightYears: 30 andWormholeAt: #().

    self assert: (board stepsFromParsecs: 1) equals: (board stepsFromLightYears: 3).
]

{ #category : 'tests - instance' }
BoardTest >> testBoardInitializesCorrectNumberOfEffects [
    | board |
    board := Board of: 20 andWormholeAt: OrderedCollection new.

    self assert: board cells size equals: 20.
]

{ #category : 'tests - instance' }
BoardTest >> testBoardPreventsEntryToHyperGravityCellWithLowRoll [
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
BoardTest >> testCanEnterHyperGravityCellWithSufficientRoll [
    | board effect |
    board := Board of: 5 andWormholeAt: #().
    effect := HyperGravityEffect new.
    board cells at: 3 put: effect.

    self assert: (effect allowsEntryWithRoll: 5).
]

{ #category : 'tests - instance' }
BoardTest >> testCannotEnterHyperGravityCellWithLowRoll [
    | board effect |
    board := Board of: 5 andWormholeAt: #().
    effect := HyperGravityEffect new.
    board cells at: 3 put: effect.

    self deny: (effect allowsEntryWithRoll: 2).
]

{ #category : 'tests - instance' }
BoardTest >> testCardEffectAddsCardToShip [
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
BoardTest >> testEffectAtHandlesAllCases [
    | board customEffect |

    board := Board of: 10 andWormholeAt: {}.
    customEffect := BlackHoleEffect new.
    board cells: (Dictionary new).
    board cells at: 5 put: customEffect.
    board cells at: 8 put: NoEffect new.

    self assert: (board effectAt: 5) equals: customEffect.
    self assert: (board effectAt: 8) class equals: NoEffect.
    self assert: (board effectAt: -1) class equals: NullEffect.
    self assert: (board effectAt: 100) class equals: NullEffect.
]

{ #category : 'tests - instance' }
BoardTest >> testEffectAtReturnsCorrectEffect [
    | board customEffect |

    board := Board of: 10 andWormholeAt: {}.
    customEffect := BlackHoleEffect new.
    board cells: (Dictionary new).
    board cells at: 5 put: customEffect.
    board cells at: 8 put: NoEffect new.

    self assert: (board effectAt: 5) equals: customEffect.
    self assert: (board effectAt: 8) class equals: NoEffect.
]

{ #category : 'tests - instance' }
BoardTest >> testHyperGravityAllowsEntryWhenRollIsSufficient [
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
BoardTest >> testHyperGravityEffectHasCorrectDefaultRoll [
    | effect |
    effect := HyperGravityEffect new.
    self assert: effect requiredRoll equals: 4.
]

{ #category : 'tests - instance' }
BoardTest >> testHyperJumpEffectJumpsShipForward [
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
BoardTest >> testInvalidBoardCellCountRaisesError [
    self
        should: [Board of: 0 andWormholeAt: #(). ]
        raise: Error
        withMessageText: 'Board must have a positive number of cells'
]

{ #category : 'tests - instance' }
BoardTest >> testInvalidBoardWithInvalidWormholeRaisesError [
    | fakeWormhole |
    fakeWormhole := Object new.

    self
        should: [ Board of: 10 andWormholeAt: fakeWormhole ]
        raise: Error
        withMessageText: 'All wormholes must be valid objects'
]

{ #category : 'tests - instance' }
BoardTest >> testIsGoalReached [
    | board |

    board := Board of: 10 andWormholeAt: #().

    self assert: (board isPositionReachedAt: 10).
    self assert: (board isPositionReachedAt: 11).

    self deny: (board isPositionReachedAt: 9).
]

{ #category : 'tests - instance' }
BoardTest >> testIsGoalReachedAtReturnsFalseIfPositionLower [
    | board |

    board := Board of: 5 andWormholeAt: {}.

    self deny: (board isPositionReachedAt: 4).
]

{ #category : 'tests - instance' }
BoardTest >> testIsGoalReachedAtReturnsTrueIfPositionEqual [
    | board |

    board := Board of: 5 andWormholeAt: {}.

    self assert: (board isPositionReachedAt: 5).
]

{ #category : 'tests - instance' }
BoardTest >> testIsGoalReachedAtReturnsTrueIfPositionGreater [
    | board |

    board := Board of: 5 andWormholeAt: {}.

    self assert: (board isPositionReachedAt: 7).
]

{ #category : 'tests - instance' }
BoardTest >> testLapDoesNotIncrementWhenStayingWithinBounds [
    | board ship newPosition |

    board := Board of: 10 andWormholeAt: OrderedCollection new.

    ship := Spaceship withName: 'Lucas'.
    ship moveTo: 3.

    newPosition := board calculateNewPositionFrom: ship position after: 4 moves: ship.

    self assert: newPosition equals: 7.
    self assert: ship lap equals: 0.
]

{ #category : 'tests - instance' }
BoardTest >> testLapIncrementsWhenPassingLastCell [
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
BoardTest >> testMoonWalkEffectMovesOtherSpaceshipsBackwards [
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
BoardTest >> testMoveShipBackwardWithoutManager [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Falcon'.
    ship moveTo: 4.

    board registerShips: { ship }.
    board moveShip: ship backward: 2.

    self assert: ship position equals: 2.
]

{ #category : 'tests - instance' }
BoardTest >> testMoveShipForwardWithoutManager [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Falcon'.
    ship moveTo: 1.

    board registerShips: { ship }.
    board moveShip: ship forward: 2.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
BoardTest >> testMoveShipForwardWrapsAround [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Wrap'.
    ship moveTo: 4.

    board registerShips: { ship }.
    board moveShip: ship forward: 3.

    self assert: ship position equals: 2.
]

{ #category : 'tests - instance' }
BoardTest >> testMoveShipBackwardWrapsAround [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'BackWrap'.
    ship moveTo: 1.

    board registerShips: { ship }.
    board moveShip: ship backward: 3.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
BoardTest >> testMoveShipToWithoutManager [
    | board ship |
    board := Board of: 5 andWormholeAt: #().
    ship := Spaceship withName: 'Falcon'.
    ship moveTo: 0.

    board registerShips: { ship }.
    board moveShip: ship to: 3.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
BoardTest >> testPositionOfWithoutManager [
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
BoardTest >> testPositionWithoutWormholeReturnsSame [
    | board |
    board := Board of: 10 andWormholeAt: #().

    self assert: (board applyWormholeIfPresentAt: 5) equals: 5.
]

{ #category : 'tests - instance' }
BoardTest >> testRandomEffectProducesRecognizedClass [
    | board effect valid |
    board := Board of: 5 andWormholeAt: #().
    effect := board randomEffect.
    valid := { NoEffect. BlackHoleEffect. HyperGravityEffect.
        MoonWalkEffect. HyperJumpEffect. AtomicBombEffect }.

    self assert: (valid anySatisfy: [ :cls | effect class = cls ]).
]

{ #category : 'tests - instance' }
BoardTest >> testRegisterShipsAndMovesWithManager [
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
BoardTest >> testStepsFromDistanceConvertsToParsecs [
    | board distParsecs distLightYears |
    board := Board of: 10 length: 9 andWormholeAt: #().
    distParsecs := Distance parsecs: 3.
    distLightYears := Distance lightYears: 9.

    self assert:
        (board stepsFromDistance: distParsecs)
            equals: (board stepsFromParsecs: 3).
    self assert:
        (board stepsFromDistance: distLightYears)
            equals: (board stepsFromParsecs: 3).
]

{ #category : 'tests - instance' }
BoardTest >> testStepsFromLightYearsConvertsCorrectly [
    | board |
    board := Board of: 10 lengthLightYears: 9 andWormholeAt: #().

    self assert: (board stepsFromLightYears: 3) equals: (board stepsFromParsecs: 1).
]

{ #category : 'tests - instance' }
BoardTest >> testWormholeTransportsCorrectly [
    | board |
    board := Board of: 20 andWormholeAt: (OrderedCollection withAll: {
        Wormhole from: 2 to: 10.
        Wormhole from: 10 to: 2.
    }).

    self assert: (board applyWormholeIfPresentAt: 2) equals: 10.
    self assert: (board applyWormholeIfPresentAt: 10) equals: 2.
]

{ #category : 'tests - instance' }
BoardTest >> testAddAndRemoveWormhole [
    | board wormhole |
    board := Board of: 5 andWormholeAt: {}.
    wormhole := Wormhole from: 1 to: 3.
    board addWormhole: wormhole.
    self assert: (board applyWormholeIfPresentAt: 1) equals: 3.
    board removeWormhole: wormhole.
    self assert: (board applyWormholeIfPresentAt: 1) equals: 1.
]

{ #category : 'tests - instance' }
BoardTest >> testReverseAtReversesWormhole [
    | board |
    board := Board of: 5 andWormholeAt: { Wormhole from: 1 to: 4 }.
    board reverseAt: 1.
    self assert: (board applyWormholeIfPresentAt: 1) equals: -1.
    self assert: (board applyWormholeIfPresentAt: 4) equals: 6.
]

{ #category : 'tests - instance' }
BoardTest >> testReverseEffectAtReplacesEffect [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := BlackHoleEffect new.
    board cells at: 2 put: effect.
    board reverseEffectAt: 2.
    self assert: (board effectAt: 2) class equals: ReversedEffect.
]

{ #category : 'tests - instance' }
BoardTest >> testReverseEffectAtSkipsAtomicBomb [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := AtomicBombEffect new.
    board cells at: 3 put: effect.
    board reverseEffectAt: 3.
    self assert: (board effectAt: 3) class equals: AtomicBombEffect.
]

{ #category : 'tests - instance' }
BoardTest >> testConvertToParsecsHandlesNumbersAndDistances [
    self assert: (Board convertToParsecs: 5) equals: 5.
    self assert: (Board convertToParsecs: (Distance parsecs: 3)) equals: 3.
]

{ #category : 'tests - instance' }
BoardTest >> testLastMoveForTracksMovementAndCanBeCleared [
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
BoardTest >> testTotalLengthInParsecsAccessorReturnsLength [
    | board |
    board := Board of: 5 length: 8 andWormholeAt: {}.
    self assert: board totalLengthInParsecs equals: 8.
]

{ #category : 'tests - instance' }
BoardTest >> testBoardCreationWithoutRandomEffectsProducesNoEffects [
    | board |
    board := Board of: 5 andWormholeAt: {} withRandomEffects: false.

    self assert: (board cells values allSatisfy: [ :each | each class = NoEffect ]).
]

{ #category : 'tests - instance' }
BoardTest >> testPopulateRandomEffectsProducesRecognizedClasses [
    | board valid |
    board := Board of: 5 andWormholeAt: {} withRandomEffects: false.
    valid := { NoEffect. BlackHoleEffect. HyperGravityEffect. MoonWalkEffect. HyperJumpEffect. AtomicBombEffect }.

    board populateRandomEffects.
    self assert: (board cells values allSatisfy: [ :e | valid anySatisfy: [ :cls | e class = cls ] ]).
]

{ #category : 'tests - instance' }
BoardTest >> testDrawCardReturnsACard [
    | board card |
    board := Board of: 5 andWormholeAt: {}.
    card := board drawCard.

    self assert: (Card withAllSubclasses includes: card class).
]

{ #category : 'tests - instance' }
BoardTest >> testDetermineNewPositionAppliesWormholeWhenNoSteps [
    | board wormhole |
    wormhole := Wormhole from: 1 to: 4.
    board := Board of: 5 andWormholeAt: { wormhole }.

    self assert: (board determineNewPositionFrom: 1 after: 0 withRoll: 0) equals: 4.
]

{ #category : 'tests - instance' }
BoardTest >> testDetermineNewPositionBackwardIgnoresHyperGravity [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := HyperGravityEffect new.
    board cells at: 2 put: effect.

    self assert: (board determineNewPositionFrom: 2 after: -1 withRoll: 1) equals: 1.
]

{ #category : 'tests - instance' }
BoardTest >> testInvalidBoardLengthMismatchRaisesError [
    self
        should: [ Board of: 5 length: 10 lengthLightYears: 5 andWormholeAt: {} ]
        raise: Error
        withMessageText: 'Length mismatch between parsecs and light years'.
]
{ #category : 'tests - instance' }
BoardTest >> testShipsReturnsRegisteredShips [
    | board ship1 ship2 |
    board := Board of: 3 andWormholeAt: {}.
    ship1 := Spaceship withName: 'S1'.
    ship2 := Spaceship withName: 'S2'.
    board registerShips: { ship1. ship2 }.
    self assert: (board ships includes: ship1).
    self assert: (board ships includes: ship2).
    self assert: board ships size equals: 2.
]

{ #category : 'tests - instance' }
BoardTest >> testValidateAsBoardReturnsSelf [
    | board |
    board := Board of: 3 andWormholeAt: {}.
    self assert: (board validateAsBoard) equals: board.
]

{ #category : 'tests - instance' }
BoardTest >> testCellsSetterUpdatesCells [
    | board newCells |
    board := Board of: 3 andWormholeAt: {}.
    newCells := Dictionary new.
    newCells at: 0 put: NoEffect new.
    board cells: newCells.
    self assert: board cells equals: newCells.
    self assert: board cellCount equals: 1.
]
