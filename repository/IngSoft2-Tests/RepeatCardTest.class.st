Class {
    #name : 'RepeatCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'helpers' }
RepeatCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
RepeatCardTest >> testApplyEffectDoesNothing [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Enterprise' 'Defiant');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Enterprise'.
    card := RepeatCard new.

    card applyEffectTo: ship inGame: game.

    self assert: ship position equals: 0.
]

{ #category : 'tests' }
RepeatCardTest >> testPlayOnDoesNothing [
    | scenario game ship |
    scenario := self builder
        withShipNames: #('Voyager' 'Enterprise');
        boardWithCells: 5;
        diceWithSides: 1;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Voyager'.
    card := RepeatCard new.

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
