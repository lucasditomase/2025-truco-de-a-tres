Class {
    #name : 'ReversalCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesBlackHoleEffect [
    | board ship ship2 card game |
    board := Board of: 15 andWormholeAt: {}.
    board cells at: 5 put: BlackHoleEffect new.
    ship := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship moveTo: 5.
    board registerShips: { ship. ship2 }.
    game := Game startWithShips: { ship. ship2 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship position equals: 9.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseWormholeMakesExitTwoWays [
    | worm board ship ship2 card game |
    worm := Wormhole from: 3 to: 10.
    board := Board of: 20 andWormholeAt: { worm }.
    ship := Spaceship withName: 'A'.
    ship2 := Spaceship withName: 'B'.
    board registerShips: { ship. ship2 }.
    game := Game startWithShips: { ship. ship2 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    ship moveTo: 3.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    self assert: (board applyWormholeIfPresentAt: 3) equals: 10.
    self assert: (board applyWormholeIfPresentAt: 10) equals: 3.
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesHyperGravityEffect [
    | board ship ship2 card game |
    board := Board of: 15 andWormholeAt: {}.
    board cells at: 4 put: HyperGravityEffect new.
    ship := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship moveTo: 4.
    board registerShips: { ship. ship2 }.
    game := Game startWithShips: { ship. ship2 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship position equals: 5.
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesHyperJumpEffect [
    | board ship ship2 effect card game steps |
    board := Board of: 10 length: 10 andWormholeAt: {}.
    effect := HyperJumpEffect withValues: #(2).
    board cells at: 4 put: effect.
    ship := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship moveTo: 4.
    board registerShips: { ship. ship2 }.
    game := Game startWithShips: { ship. ship2 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    steps := board stepsFromParsecs: effect peekJumpValue.
    board applyEffectTo: ship.
    self assert: ship position equals: 4 - steps.
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesMoonWalkEffect [
    | board ship ship2 card game |
    board := Board of: 10 andWormholeAt: {}.
    board cells at: 5 put: MoonWalkEffect new.
    ship := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship moveTo: 5.
    ship2 moveTo: 1.
    board registerShips: { ship. ship2 }.
    game := Game startWithShips: { ship. ship2 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship position equals: 5.
    self assert: ship2 position equals: 3.
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesCardEffect [
    | board ship ship2 removalCard card game |
    board := Board of: 10 andWormholeAt: {}.
    board cells at: 5 put: CardEffect new.
    ship := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    removalCard := OverloadCard forShip: ship.
    ship addCard: removalCard.
    ship moveTo: 5.
    board registerShips: { ship. ship2 }.
    game := Game startWithShips: { ship. ship2 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship cards isEmpty.
]
