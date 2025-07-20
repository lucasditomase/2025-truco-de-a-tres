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
    self assert: (reversed perform: #original) equals: baseEffect.
    self assert: (reversed perform: #wrapped) equals: baseEffect.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesBlackHole [
    | ship effect reversed |
    ship := Spaceship withName: 'BH'.
    effect := BlackHoleEffect new.
    reversed := ReversedEffect of: effect.
    ship moveTo: 0.
    reversed applyEffectTo: ship inBoard: NullBoard new.
    self assert: ship position equals: 4.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesHyperGravity [
    | ship effect reversed |
    ship := Spaceship withName: 'HG'.
    effect := HyperGravityEffect new.
    reversed := ReversedEffect of: effect.
    ship moveTo: 2.
    reversed applyEffectTo: ship inBoard: NullBoard new.
    self assert: ship position equals: 3.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesHyperJump [
    | board ship effect reversed steps |
    board := Board of: 10 length: 10 andWormholeAt: #().
    ship := Spaceship withName: 'HJ'.
    board registerShips: { ship }.
    effect := HyperJumpEffect withValues: #(2).
    reversed := ReversedEffect of: effect.
    ship moveTo: 5.
    steps := (2 / board totalLengthInParsecs * board cellCount) rounded.
    reversed applyEffectTo: ship inBoard: board.
    self assert: ship position equals: 5 - steps.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesMoonWalk [
    | board ship1 ship2 effect reversed |
    board := Board of: 10 andWormholeAt: {}.
    ship1 := Spaceship withName: 'S1'.
    ship2 := Spaceship withName: 'S2'.
    ship1 moveTo: 3.
    ship2 moveTo: 3.
    board registerShips: { ship1. ship2 }.
    effect := MoonWalkEffect new.
    reversed := ReversedEffect of: effect.
    reversed applyEffectTo: ship1 inBoard: board.
    self assert: ship1 position equals: 3.
    self assert: ship2 position equals: 5.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToReversesCardEffect [
    | ship card effect reversed |
    ship := Spaceship withName: 'Carded'.
    card := AccelerationCard new.
    ship addCard: card.
    effect := CardEffect new.
    reversed := ReversedEffect of: effect.
    reversed applyEffectTo: ship inBoard: NullBoard new.
    self assert: ship cards isEmpty.
]

{ #category : 'tests' }
ReversedEffectTest >> testApplyEffectToOtherEffectDoesNothing [
    | ship effect reversed |
    ship := Spaceship withName: 'None'.
    ship moveTo: 4.
    effect := NoEffect new.
    reversed := ReversedEffect of: effect.
    reversed applyEffectTo: ship inBoard: NullBoard new.
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
