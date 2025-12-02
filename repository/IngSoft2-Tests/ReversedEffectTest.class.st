Class {
    #name : 'ReversedEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ReversedEffectTest >> testInitializationStoresOriginalAndDecorates [
    | baseEffect reversed |
    baseEffect := BlackHoleEffect new.
    reversed := ReversedEffect of: baseEffect.
    self assert: reversed original equals: baseEffect.
    self assert: reversed wrapped equals: baseEffect.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesBlackHole [
    | scenario board ship effect reversed |
    scenario := (GameTestBuilder new boardWithCells: 10) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    board moveShip: ship to: 0.
    reversed applyEffectTo: ship inBoard: board.
    self assert: ship position equals: 4.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesHyperGravity [
    | scenario board ship effect reversed |
    scenario := (GameTestBuilder new boardWithCells: 8) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    effect := HyperGravityEffect new.
    reversed := ReversedEffect of: effect.
    board moveShip: ship to: 2.
    reversed applyEffectTo: ship inBoard: board.
    self assert: ship position equals: 2.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesHyperJump [
    | scenario board ship effect reversed steps |
    scenario := (GameTestBuilder new boardWithCells: 10) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    effect := HyperJumpEffect withValues: #(2).
    reversed := ReversedEffect of: effect.
    board moveShip: ship to: 5.
    steps := (2 / board totalLengthInParsecs * board cellCount) rounded.
    reversed applyEffectTo: ship inBoard: board.
    self assert: ship position equals: 5 - steps.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesMoonWalk [
    | scenario board alpha beta effect reversed |
    scenario := (GameTestBuilder new boardWithCells: 10) build.
    board := scenario game board.
    alpha := scenario shipNamed: 'Alpha'.
    beta := scenario shipNamed: 'Beta'.
    effect := MoonWalkEffect withSteps: 3.
    reversed := ReversedEffect of: effect.
    board moveShip: alpha to: 3.
    board moveShip: beta to: 3.
    reversed applyEffectTo: alpha inBoard: board.
    self assert: alpha position equals: 3.
    self assert: beta position equals: 6.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesCardEffect [
    | scenario ship card effect reversed |
    scenario := GameTestBuilder new build.
    ship := scenario shipNamed: 'Alpha'.
    ship cards copy do: [ :each | ship removeCard: each ].
    card := AccelerationCard new.
    ship addCard: card.
    effect := CardEffect new.
    reversed := ReversedEffect of: effect.
    reversed applyEffectTo: ship inBoard: scenario game board.
    self assert: ship cards isEmpty.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToOtherEffectDoesNothing [
    | scenario board ship effect reversed |
    scenario := (GameTestBuilder new boardWithCells: 10) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    effect := NoEffect new.
    reversed := ReversedEffect of: effect.
    board moveShip: ship to: 4.
    reversed applyEffectTo: ship inBoard: board.
    self assert: ship position equals: 4.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyToUsesNullBoard [
    | ship effect reversed |
    ship := Spaceship withName: 'Null'.
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    reversed applyTo: ship.
    self assert: ship position equals: 4.
]

{ #category : 'tests' }
ReversedEffectTest >> testReversedReturnsOriginal [
    | effect reversed |
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    self assert: reversed reversed equals: effect.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyToInBoardAppliesEffect [
    | scenario board ship effect reversed |
    scenario := (GameTestBuilder new boardWithCells: 5) build.
    board := scenario game board.
    ship := scenario shipNamed: 'Alpha'.
    board moveShip: ship to: 0.
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    reversed applyTo: ship inBoard: board.
    self assert: ship position equals: 4.
]
