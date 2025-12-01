Class {
    #name : 'RepeatCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RepeatCardTest >> testApplyEffectDoesNothing [
    | card ship other board dice game |
    card := RepeatCard new.
    ship := Spaceship withName: 'Enterprise'.
    other := Spaceship withName: 'Defiant'.
    board := Board of: 5 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship. other } board: board dice: dice laps: 1.

    card applyEffectTo: ship inGame: game.

    self assert: ship position equals: 0.
]

{ #category : 'tests' }
RepeatCardTest >> testPlayOnDoesNothing [
    | card ship other board dice game |
    card := RepeatCard new.
    ship := Spaceship withName: 'Voyager'.
    other := Spaceship withName: 'Enterprise'.
    board := Board of: 5 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship. other } board: board dice: dice laps: 1.

    card playOn: ship inGame: game.

    self assert: ship position equals: 0.
]

{ #category : 'tests' }
RepeatCardTest >> testResolveTargetDefaultsToActingShip [
    | card ship |
    card := RepeatCard new.
    ship := Spaceship withName: 'Default'.

    self assert: (card resolveTargetFor: ship) equals: ship.
]

{ #category : 'tests' }
RepeatCardTest >> testResolveTargetUsesExplicitTarget [
    | target card ship |
    target := Spaceship withName: 'Target'.
    card := RepeatCard targeting: target.
    ship := Spaceship withName: 'Caller'.

    self assert: (card resolveTargetFor: ship) equals: target.
    self assert: card targetShip equals: target.
]

{ #category : 'tests' }
RepeatCardTest >> testRecordsLastEffectReturnsFalse [
    self deny: RepeatCard new recordsLastEffect.
]
