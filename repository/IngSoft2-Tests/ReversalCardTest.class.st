Class {
    #name : 'ReversalCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ReversalCardTest >> testReverseMoonWalkEffect [
    | board ship1 ship2 ship3 card game |
    board := Board of: 12 andWormholeAt: {}.
    board cells at: 5 put: MoonWalkEffect new.
    ship1 := Spaceship withName: 'One'.
    ship2 := Spaceship withName: 'Two'.
    ship3 := Spaceship withName: 'Three'.
    ship1 moveTo: 5.
    ship2 moveTo: 6.
    ship3 moveTo: 4.
    board registerShips: { ship1. ship2. ship3 }.
    game := Game startWithShips: { ship1. ship2. ship3 } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card playOn: ship1 inGame: game.
    board applyEffectTo: ship1.
    self assert: ship2 position equals: 8.
    self assert: ship3 position equals: 6.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseWormholeMovesToPreviousLap [
    | board ship other card game worm1 worm2 newPos |
    worm1 := Wormhole from: 3 to: 10.
    worm2 := Wormhole from: 10 to: 3.
    board := Board of: 12 andWormholeAt: { worm1. worm2 }.
    ship := Spaceship withName: 'A'.
    other := Spaceship withName: 'B'.
    ship moveTo: 3.
    board registerShips: { ship. other }.
    game := Game startWithShips: { ship. other } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    ship instVarNamed: 'lap' put: 1.
    card := ReversalCard new.
    card playOn: ship inGame: game.
    newPos := board applyWormholeIfPresentAt: 3 forShip: ship.
    self assert: newPos equals: 10.
    self assert: ship lap equals: 0.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseCardEffectDiscardsCard [
    | board ship cardEffect card game discarded |
    board := Board of: 6 andWormholeAt: {}.
    cardEffect := CardEffect new.
    board cells at: 2 put: cardEffect.
    ship := Spaceship withName: 'X'.
    ship addCard: OverloadCard forShip: ship.
    ship moveTo: 2.
    board registerShips: { ship }.
    game := Game startWithShips: { ship. (Spaceship withName: 'Y') } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card playOn: ship inGame: game.
    discarded := ship cards size.
    board applyEffectTo: ship.
    self assert: ship cards size equals: discarded - 1.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseBlackHoleEffectMovesShipForward [
    | board ship card game |
    board := Board of: 6 andWormholeAt: {}.
    board cells at: 2 put: BlackHoleEffect new.
    ship := Spaceship withName: 'BH'.
    ship moveTo: 2.
    board registerShips: { ship }.
    game := Game startWithShips: { ship } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card playOn: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship position equals: 6.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseHyperGravityEffectMovesShipForwardByOne [
    | board ship card game |
    board := Board of: 6 andWormholeAt: {}.
    board cells at: 2 put: HyperGravityEffect new.
    ship := Spaceship withName: 'HG'.
    ship moveTo: 2.
    board registerShips: { ship }.
    game := Game startWithShips: { ship } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card playOn: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship position equals: 3.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseHyperJumpEffectMovesShipBackward [
    | board ship card game effect expected |
    board := Board of: 10 length: 10 andWormholeAt: {}.
    effect := HyperJumpEffect withValues: #(3).
    expected := board stepsFromParsecs: 3.
    board cells at: 4 put: effect.
    ship := Spaceship withName: 'HJ'.
    ship moveTo: 4.
    board registerShips: { ship }.
    game := Game startWithShips: { ship } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card playOn: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship position equals: 4 - expected.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseWormholeFromExitMovesToNextLap [
    | board ship other card game worm1 worm2 newPos |
    worm1 := Wormhole from: 3 to: 10.
    worm2 := Wormhole from: 10 to: 3.
    board := Board of: 12 andWormholeAt: { worm1. worm2 }.
    ship := Spaceship withName: 'A'.
    other := Spaceship withName: 'B'.
    ship moveTo: 10.
    board registerShips: { ship. other }.
    game := Game startWithShips: { ship. other } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card playOn: ship inGame: game.
    newPos := board applyWormholeIfPresentAt: 10 forShip: ship.
    self assert: newPos equals: 3.
    self assert: ship lap equals: 1.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseNoEffectMarksCellButDoesNothing [
    | board ship card game |
    board := Board of: 5 andWormholeAt: {}.
    ship := Spaceship withName: 'N'.
    ship moveTo: 1.
    board registerShips: { ship }.
    game := Game startWithShips: { ship } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card playOn: ship inGame: game.
    self assert: (board isCellReversed: 1).
    board applyEffectTo: ship.
    self assert: ship position equals: 1.
]
