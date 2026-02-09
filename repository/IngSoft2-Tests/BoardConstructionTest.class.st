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
        should: [ Board of: 10 length: (Distance parsecs: 10) lengthLightYears: 30 andWormholeAt: #() ]
        raise: Error
        withMessageText: 'Length mismatch between parsecs and light years'
]
