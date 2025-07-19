Class {
    #name : 'ReversalCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ReversalCardTest >> testActivateForReversesBlackHoleEffect [
    | board ship card game |
    board := Board of: 15 andWormholeAt: {}.
    board cells at: 5 put: BlackHoleEffect new.
    ship := Spaceship withName: 'One'.
    ship moveTo: 5.
    board registerShips: { ship }.
    game := Game startWithShips: { ship } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    board applyEffectTo: ship.
    self assert: ship position equals: 9.
]

{ #category : 'tests' }
ReversalCardTest >> testReverseWormholeMakesExitTwoWays [
    | worm board ship card game |
    worm := Wormhole from: 3 to: 10.
    board := Board of: 20 andWormholeAt: { worm }.
    ship := Spaceship withName: 'A'.
    board registerShips: { ship }.
    game := Game startWithShips: { ship } board: board dice: (DiceCup with: { Die withSides: 1 }) laps: 1.
    ship moveTo: 3.
    card := ReversalCard new.
    card activateFor: ship inGame: game.
    self assert: (board applyWormholeIfPresentAt: 3) equals: 10.
    self assert: (board applyWormholeIfPresentAt: 10) equals: 3.
]
