Class {
    #name : 'NullEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests - instance' }
NullEffectTest >> testApplyToInBoardDoesNothing [
    | effect ship board |
    effect := NullEffect new.
    ship := Spaceship withName: 'Test'.
    board := NullBoard new.
    ship moveTo: 3.
    effect applyTo: ship inBoard: board.
    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
NullEffectTest >> testApplyToInContextReturnsSelf [
    | effect ship board |
    effect := NullEffect new.
    ship := Spaceship withName: 'Context'.
    board := NullBoard new.
    self assert: (effect applyTo: ship inContextOf: { ship } inBoard: board) equals: effect.
]

{ #category : 'tests - instance' }
NullEffectTest >> testAllowsEntryWithRollAlwaysTrue [
    self assert: (NullEffect new allowsEntryWithRoll: 5).
]

{ #category : 'tests - instance' }
NullEffectTest >> testReversedReturnsSelf [
    | effect |
    effect := NullEffect new.
    self assert: effect reversed equals: effect.
]

{ #category : 'tests - instance' }
NullEffectTest >> testApplyEffectToDelegatesToApplyTo [
    | effect ship board |
    effect := NullEffect new.
    ship := Spaceship withName: 'Apply'.
    ship moveTo: 4.
    board := NullBoard new.

    effect applyEffectTo: ship inBoard: board.

    self assert: ship position equals: 4.
]

{ #category : 'tests - instance' }
NullEffectTest >> testConsumesFuelIsTrue [
    self assert: NullEffect new consumesFuel.
]
