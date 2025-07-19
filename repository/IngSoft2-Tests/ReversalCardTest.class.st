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
    board moveShip: ship to: 3.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    self assert: (board applyWormholeIfPresentAt: 3) equals: (10 - board cellCount).
    self assert: (board applyWormholeIfPresentAt: 10) equals: (3 + board cellCount).
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
    ship cards removeAll.
    ship addCard: removalCard.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    board applyEffectTo: ship.
    self deny: (ship cards includes: removalCard).
]

{ #category : 'tests' }
ReversalCardTest >> testActivateForDoesNothingWithAtomicBombEffect [
    | board ship ship2 card game effect |
    board := Board of: 10 andWormholeAt: {}.
    effect := AtomicBombEffect new.
    board cells at: 5 put: effect.
    ship := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship moveTo: 5.
    ship2 moveTo: 3.
    board registerShips: { ship. ship2 }.
    game := Game startWithShips: { ship. ship2 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    self assert: (board cells at: 5) class equals: AtomicBombEffect.
    (board cells at: 5) applyTo: ship inContextOf: { ship. ship2 } inBoard: board.
    self assert: ship position equals: 0.
    self assert: ship2 position equals: 0.
]
