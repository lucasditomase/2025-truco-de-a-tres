Class {
    #name : 'ReversalCardTest',
    #superclass : 'GameIntegrationTest',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
ReversalCardTest >> playReversalFor: aShip inGame: aGame [
    | card |
    card := ReversalCard new.
    aShip addCard: card.
    self ensureTurnOf: aShip inGame: aGame.
    aShip playCard: card inGame: aGame.
    ^ card
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesBlackHoleEffect [
    | scenario game board ship |
    scenario := self builder
        boardWithCells: 15;
        withEffect: BlackHoleEffect new at: 5;
        build.
    game := scenario game.
    board := game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 5.

    self playReversalFor: ship inGame: game.
    board applyEffectTo: ship.

    self assert: ship position equals: 9
]

{ #category : 'tests' }
ReversalCardTest >> testReverseWormholeMakesExitTwoWays [
    | scenario game board ship |
    scenario := self builder
        boardFactory: [ Board of: 20 andWormholeAt: { Wormhole from: 3 to: 10 } ];
        build.
    game := scenario game.
    board := game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 3.

    self playReversalFor: ship inGame: game.

    self assert: (board applyWormholeIfPresentAt: 3) equals: (10 - board cellCount).
    self assert: (board applyWormholeIfPresentAt: 10) equals: (3 + board cellCount)
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesHyperGravityEffect [
    | scenario game board ship |
    scenario := self builder
        boardWithCells: 15;
        withEffect: HyperGravityEffect new at: 4;
        build.
    game := scenario game.
    board := game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 4.

    self playReversalFor: ship inGame: game.
    board applyEffectTo: ship.

    self assert: ship position equals: 4
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesHyperJumpEffect [
    | scenario game board ship effect steps |
    effect := HyperJumpEffect withValues: #(2).
    scenario := self builder
        boardWithCells: 10;
        withEffect: effect at: 4;
        build.
    game := scenario game.
    board := game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 4.

    self playReversalFor: ship inGame: game.
    steps := board stepsFromParsecs: effect peekJumpValue.
    board applyEffectTo: ship.

    self assert: ship position equals: 4 - steps
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesMoonWalkEffect [
    | scenario game board alpha beta effect |
    effect := MoonWalkEffect withSteps: 2.
    scenario := self builder
        boardWithCells: 10;
        withEffect: effect at: 5;
        build.
    game := scenario game.
    board := game board.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    board moveShip: alpha to: 5.
    board moveShip: beta to: 1.

    self playReversalFor: alpha inGame: game.
    board applyEffectTo: alpha.

    self assert: alpha position equals: 5.
    self assert: beta position equals: 3
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesCardEffect [
    | scenario game board ship removalCard |
    scenario := self builder
        boardWithCells: 10;
        withEffect: CardEffect new at: 5;
        build.
    game := scenario game.
    board := game board.
    ship := scenario shipNamed: 'Alpha'.
    removalCard := OverloadCard forShip: ship.
    ship cards removeAll.
    ship addCard: removalCard.
    board moveShip: ship to: 5.

    self playReversalFor: ship inGame: game.
    board applyEffectTo: ship.

    self deny: (ship cards includes: removalCard)
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForDoesNothingWithAtomicBombEffect [
    | scenario game board alpha beta |
    scenario := self builder
        boardWithCells: 10;
        withEffect: AtomicBombEffect new at: 5;
        build.
    game := scenario game.
    board := game board.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    board moveShip: alpha to: 5.
    board moveShip: beta to: 3.

    self playReversalFor: alpha inGame: game.

    self assert: (board effectAt: 5) class equals: AtomicBombEffect.
    board applyEffectTo: alpha.

    self assert: alpha position equals: 0.
    self assert: beta position equals: 0
]
