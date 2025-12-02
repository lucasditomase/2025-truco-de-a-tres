Class {
    #name : 'EffectDecoratorTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
EffectDecoratorTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'tests' }
EffectDecoratorTest >> testApplyToWithoutWrappedEffectDoesNothing [
    | scenario ship decorator originalPosition |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceWithSides: 6;
        build.
    ship := scenario shipNamed: 'Alpha'.
    decorator := EffectDecorator new.

    ship moveForward: 3.
    originalPosition := ship position.

    decorator applyTo: ship.

    self assert: ship position equals: originalPosition.
]

{ #category : 'tests' }
EffectDecoratorTest >> testEffectDecoratorDecorateSetsWrappedEffect [
    | baseEffect decorator |
    baseEffect := NoEffect new.
    decorator := EffectDecorator new decorate: baseEffect.

    self assert: decorator wrapped equals: baseEffect.
]
