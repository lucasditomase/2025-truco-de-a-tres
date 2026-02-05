Class {
    #name : 'BoardConstructionTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'asserting' }
BoardConstructionTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCellCountIsCorrect [
    | board size |

    size := 7.
    board := Board of: size andWormholeAt: #().

    self assert: board cellCount equals: size.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCellsContainRecognizedEffects [
    | board validClasses |

    validClasses := { NoEffect. BlackHoleEffect. HyperGravityEffect.
        MoonWalkEffect. HyperJumpEffect. AtomicBombEffect }.

    board := Board of: 20 andWormholeAt: OrderedCollection new.

    self assert: (board cells values allSatisfy: [:e |
        validClasses anySatisfy: [:c | e class = c ] ]).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithDistanceParsecLength [
    | board |
    board := Board of: 10 length: (Distance parsecs: 12) andWormholeAt: #().

    self assert: (board stepsFromParsecs: 3) equals: 3.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithLightYearLength [
    | board |
    board := Board of: 10 lengthLightYears: 30 andWormholeAt: #().

    self assert: (board stepsFromLightYears: 6) equals: (board stepsFromParsecs: 2).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithParsecsAndLightYears [
    | board |
    board := Board of: 10 length: 10 lengthLightYears: 30 andWormholeAt: #().

    self assert: (board stepsFromParsecs: 1) equals: (board stepsFromLightYears: 3).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardInitializesCorrectNumberOfEffects [
    | board |
    board := Board of: 20 andWormholeAt: OrderedCollection new.

    self assert: board cells size equals: 20.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testEffectAtHandlesAllCases [
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
BoardConstructionTest >> testInvalidBoardCellCountRaisesError [
    self
        should: [Board of: 0 andWormholeAt: #(). ]
        raise: Error
        withMessageText: 'Board must have a positive number of cells'
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testInvalidBoardWithInvalidWormholeRaisesError [
    | fakeWormhole |
    fakeWormhole := Object new.

    self
        should: [ Board of: 10 andWormholeAt: fakeWormhole ]
        raise: Error
        withMessageText: 'All wormholes must be valid objects'
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testRandomEffectProducesRecognizedClass [
    | board effect valid |
    board := Board of: 5 andWormholeAt: #().
    effect := board randomEffect.
    valid := { NoEffect. CardEffect. BlackHoleEffect. HyperGravityEffect.
        MoonWalkEffect. HyperJumpEffect. AtomicBombEffect }.

    self assert: (valid anySatisfy: [ :cls | effect class = cls ]).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testStepsFromDistanceConvertsToParsecs [
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
BoardConstructionTest >> testStepsFromLightYearsConvertsCorrectly [
    | board |
    board := Board of: 10 lengthLightYears: 9 andWormholeAt: #().

    self assert: (board stepsFromLightYears: 3) equals: (board stepsFromParsecs: 1).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testAddAndRemoveWormhole [
    | board wormhole |
    board := Board of: 5 andWormholeAt: {}.
    wormhole := Wormhole from: 1 to: 3.
    board addWormhole: wormhole.
    self assert: (board applyWormholeIfPresentAt: 1) equals: 3.
    board removeWormhole: wormhole.
    self assert: (board applyWormholeIfPresentAt: 1) equals: 1.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testConvertToParsecsHandlesNumbersAndDistances [
    self assert: (Board convertToParsecs: 5) equals: 5.
    self assert: (Board convertToParsecs: (Distance parsecs: 3)) equals: 3.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testTotalLengthInParsecsAccessorReturnsLength [
    | board |
    board := Board of: 5 length: 8 andWormholeAt: {}.
    self assert: board totalLengthInParsecs equals: 8.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithoutRandomEffectsProducesNoEffects [
    | board |
    board := Board of: 5 andWormholeAt: {} withRandomEffects: false.

    self assert: (board cells values allSatisfy: [ :each | each class = NoEffect ]).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testPopulateRandomEffectsProducesRecognizedClasses [
    | board valid |
    board := Board of: 5 andWormholeAt: {} withRandomEffects: false.
    valid := { NoEffect. CardEffect. BlackHoleEffect. HyperGravityEffect. MoonWalkEffect. HyperJumpEffect. AtomicBombEffect }.

    board populateRandomEffects.
    self assert: (board cells values allSatisfy: [ :e | valid anySatisfy: [ :cls | e class = cls ] ]).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testConfigureHyperGravityRequirementsUsesMaxRoll [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := HyperGravityEffect new.
    board cells at: 2 put: effect.
    "board configureHyperGravityRequirementsWithMaxRoll: 3."
    self assert: ((1 to: 3) includes: effect requiredRoll).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testRandomEffectForRollDistributesAccordingToSpecification [
    | board |
    board := Board of: 5 andWormholeAt: {}.

    self assert: (board randomEffectForRoll: 1) class equals: NoEffect.
    self assert: (board randomEffectForRoll: 45) class equals: CardEffect.
    self assert: (board randomEffectForRoll: 60) class equals: BlackHoleEffect.
    self assert: (board randomEffectForRoll: 70) class equals: HyperGravityEffect.
    self assert: (board randomEffectForRoll: 95) class equals: MoonWalkEffect.
    self assert: (board randomEffectForRoll: 100) class equals: HyperJumpEffect.
    self assert: (board randomEffectForRoll: 108) class equals: AtomicBombEffect.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testInvalidBoardLengthMismatchRaisesError [
    self
        should: [ Board of: 5 length: 10 lengthLightYears: 5 andWormholeAt: {} ]
        raise: Error
        withMessageText: 'Length mismatch between parsecs and light years'.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testShipsReturnsRegisteredShips [
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
BoardConstructionTest >> testCellsSetterUpdatesCells [
    | board newCells |
    board := Board of: 3 andWormholeAt: {}.
    newCells := Dictionary new.
    newCells at: 0 put: NoEffect new.
    board cells: newCells.
    self assert: board cells equals: newCells.
    self assert: board cellCount equals: 1.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testCellsSetterKeepsCellCountWhenCollectionEmpty [
    | board originalCount |
    board := Board of: 4 andWormholeAt: {}.
    originalCount := board cellCount.

    board cells: #().

    self assert: board cellCount equals: originalCount.
    self assert: board cells isEmpty.
]
