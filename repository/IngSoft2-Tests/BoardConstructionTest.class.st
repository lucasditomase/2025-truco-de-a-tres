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
        MoonWalkEffect. HyperJumpEffect. AtomicBombEffect. CardEffect }.
    board := Board of: 20 andWormholeAt: OrderedCollection new.
    self assert: (board cells values allSatisfy: [:e |
        validClasses anySatisfy: [:c | e class = c ] ]).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithLightYearsConvertsToParsecs [
    | board |
    board := Board of: 10 length: (Distance lightYears: 30) andWormholeAt: #().
    
    self assert: board totalLengthInParsecsOrZero value equals: 10.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithDistanceConversions [
    | board |
    board := Board of: 10 length: (Distance parsecs: 10) andWormholeAt: #().
    self assert: (board stepsFromParsecs: 1) equals: 1.
    self assert: (board stepsFromLightYears: 3) equals: 1.
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
    self
        should: [ Board of: 10 andWormholeAt: Object new ]
        raise: Error
        withMessageText: 'All wormholes must be valid objects'
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardStepsFromParsecsCheckZeroLength [
    self
        should: [ Board of: 10 length: 0 andWormholeAt: #() ]
        raise: Error
        withMessageText: 'Board length must be provided as a positive Distance or numeric value'
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testValidateLengthConsistencyChecksMismatch [
    self
        should: [ Board of: 10 length: (Distance parsecs: 10) lengthLightYears: 29 andWormholeAt: #() ]
        raise: Error
        withMessageText: 'Length mismatch between parsecs and light years'
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testRandomEffectDistributionFallback [
    | board effect |
    board := Board of: 10 andWormholeAt: #().
    "Force fallback by providing a roll larger than any cumulative weight"
    effect := board randomEffectForRoll: 99999.
    self assert: effect class equals: AtomicBombEffect.
]

{ #category : 'tests - class' }
BoardConstructionTest >> testBoardClassConvertToParsecs [
    | parsecs |
    parsecs := Board convertToParsecs: (Distance lightYears: 30).
    self assert: parsecs value equals: 10.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithRandomEffects [
    | board |
    board := Board of: 10 andWormholeAt: #() withRandomEffects: true.
    self assert: (board cells anySatisfy: [ :effect | effect class ~= NoEffect ]).
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardCreationWithLightYearLength [
    | board |
    board := Board of: 10 lengthLightYears: 30 andWormholeAt: #().
    self assert: board totalLengthInParsecsOrZero value equals: 10.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardHelpersAndAccessors [
    | board |
    board := Board of: 10 length: (Distance parsecs: 100) andWormholeAt: #().
    
    "Test clearLastMoves (no error)"
    board clearLastMoves.
    
    "Test totalLengthInParsecs"
    self assert: board totalLengthInParsecs value equals: 100.
    
    "Test totalEffectWeight"
    self assert: board totalEffectWeight > 0.
    
    "Test invalidEffectMessage"
    self assert: Board invalidEffectMessage equals: 'Board cells must contain effects'.
]

{ #category : 'tests - instance' }
BoardConstructionTest >> testBoardWithEmptyCells [
    | board |
    board := Board new.
    board cells: Dictionary new.
    self assert: board cellCount isNil.
]
