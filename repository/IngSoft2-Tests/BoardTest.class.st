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
        MoonWalkEffect. HyperJumpEffect. AtomicBombEffect. CardEffect }.
    board := Board of: 20 andWormholeAt: OrderedCollection new.
    self assert: (board cells values allSatisfy: [:e |
        validClasses anySatisfy: [:c | e class = c ] ]).
]

{ #category : 'tests - instance' }
BoardTest >> testBoardCreationWithDistanceConversions [
    | board |
    board := Board of: 10 length: (Distance parsecs: 10) andWormholeAt: #().
    self assert: (board stepsFromParsecs: 1) equals: 1.
    self assert: (board stepsFromLightYears: 3) equals: 1.
]

{ #category : 'tests - instance' }
BoardTest >> testEffectAtHandlesBoundaryCases [
    | board |
    board := Board of: 10 andWormholeAt: {}.
    self assert: (board effectAt: -1) class equals: NullEffect.
    self assert: (board effectAt: 11) class equals: NullEffect.
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
    self
        should: [ Board of: 10 andWormholeAt: Object new ]
        raise: Error
        withMessageText: 'All wormholes must be valid objects'
]

{ #category : 'tests - instance' }
BoardTest >> testStepsFromDistanceConvertsToParsecs [
    | board distParsecs distLightYears |
    board := Board of: 10 length: 9 andWormholeAt: #().
    distParsecs := Distance parsecs: 3.
    distLightYears := Distance lightYears: 9.
    self assert: (board stepsFromDistance: distParsecs) equals: (board stepsFromParsecs: 3).
    self assert: (board stepsFromDistance: distLightYears) equals: (board stepsFromParsecs: 3).
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
BoardTest >> testDrawCardUsesInjectedDealer [
    | board dealerCard |
    board := Board of: 5 andWormholeAt: {}.
    dealerCard := NullCard new.
    board useCardDealer: [ dealerCard ].
    self assert: board drawCard equals: dealerCard.
]

{ #category : 'tests - instance' }
BoardTest >> testUseCardDealerCyclingThroughReturnsCardsInSequence [
    | board |
    board := Board of: 5 andWormholeAt: {}.
    board useCardDealerCyclingThrough: { AdvanceCard. ShieldCard }.
    self assert: board drawCard class equals: AdvanceCard.
    self assert: board drawCard class equals: ShieldCard.
]
