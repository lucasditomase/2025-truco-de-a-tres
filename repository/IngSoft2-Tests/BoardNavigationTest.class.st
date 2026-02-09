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

{ #category : 'tests - instance' }
BoardNavigationTest >> testEffectAtHandlesBoundaryCases [
    | board |
    board := Board of: 10 andWormholeAt: {}.
    self assert: (board effectAt: -1) class equals: NullEffect.
    self assert: (board effectAt: 11) class equals: NullEffect.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testStepsFromDistanceConvertsToParsecs [
    | board distParsecs distLightYears |
    board := Board of: 10 length: 9 andWormholeAt: #().
    distParsecs := Distance parsecs: 3.
    distLightYears := Distance lightYears: 9.
    self assert: (board stepsFromDistance: distParsecs) equals: (board stepsFromParsecs: 3).
    self assert: (board stepsFromDistance: distLightYears) equals: (board stepsFromParsecs: 3).
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testAddAndRemoveWormhole [
    | board wormhole |
    board := Board of: 5 andWormholeAt: {}.
    wormhole := Wormhole from: 1 to: 3.
    board addWormhole: wormhole.
    self assert: (board applyWormholeIfPresentAt: 1) equals: 3.
    board removeWormhole: wormhole.
    self assert: (board applyWormholeIfPresentAt: 1) equals: 1.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testReverseAtReversesWormhole [
    | board |
    board := Board of: 5 andWormholeAt: { Wormhole from: 1 to: 4 }.
    board reverseAt: 1.
    self assert: (board applyWormholeIfPresentAt: 1) equals: -1.
    self assert: (board applyWormholeIfPresentAt: 4) equals: 6.
]

{ #category : 'tests' }
BoardNavigationTest >> testBoardDelegatesMovementQuery [
    | board ship |
    board := Board of: 10 andWormholeAt: #().
    ship := Spaceship withName: 'Test'.
    board registerShips: { ship }.
    
    "Test lastMoveFor: delegation"
    self assert: (board lastMoveFor: ship) isNil.
    
    "Test clearLastMoves delegation (should not raise error)"
    board clearLastMoves.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testReverseEffectAtReplacesEffect [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := BlackHoleEffect new.
    board placeEffect: effect at: 2.
    board reverseEffectAt: 2.
    self assert: (board effectAt: 2) class equals: ReversedEffect.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testReverseEffectAtSkipsAtomicBomb [
    | board effect |
    board := Board of: 5 andWormholeAt: {}.
    effect := AtomicBombEffect new.
    board placeEffect: effect at: 3.
    board reverseEffectAt: 3.
    self assert: (board effectAt: 3) class equals: AtomicBombEffect.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testDrawCardUsesInjectedDealer [
    | board dealerCard |
    board := Board of: 5 andWormholeAt: {}.
    dealerCard := NullCard new.
    board useCardDealer: [ dealerCard ].
    self assert: board drawCard equals: dealerCard.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testUseCardDealerCyclingThroughReturnsCardsInSequence [
    | board |
    board := Board of: 5 andWormholeAt: {}.
    board useCardDealerCyclingThrough: { AdvanceCard. ShieldCard }.
    self assert: board drawCard class equals: AdvanceCard.
    self assert: board drawCard class equals: ShieldCard.
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testConfigureHyperGravityRequirementsWithInvalidMaxRoll [
    | board effect defaultMax |
    board := Board of: 10 andWormholeAt: {}.
    effect := HyperGravityEffect new.
    board placeEffect: effect at: 5.
    
    board configureHyperGravityRequirementsWithMaxRoll: -5.
    
    defaultMax := GameRules defaultMaxDiceRoll.
    self deny: (effect allowsEntryWithRoll: defaultMax - 1).
    self assert: (effect allowsEntryWithRoll: defaultMax).
]

{ #category : 'tests - instance' }
BoardNavigationTest >> testValidateCardDealerChecksWaitMessage [
    | board |
    board := Board of: 10 andWormholeAt: {}.
    self
        should: [ board useCardDealer: Object new ]
        raise: Error
        withMessageText: 'Card dealer must respond to #value'
]
