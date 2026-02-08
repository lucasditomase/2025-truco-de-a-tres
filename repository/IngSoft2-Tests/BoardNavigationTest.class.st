Class {
    #name : 'BoardNavigationTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

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
