Class {
    #name : 'MoonWalkEffect',
    #superclass : 'EffectDecorator',
    #instVars : [
        'steps'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
MoonWalkEffect class >> withSteps: aNumber [
    ^ self new initializeWithSteps: aNumber
]

{ #category : 'operations' }
MoonWalkEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    ^ self.
]

{ #category : 'initialization' }
MoonWalkEffect >> initialize [
    super initialize.
    steps := 2.
    ^ self
]

{ #category : 'initialization' }
MoonWalkEffect >> initializeWithSteps: aNumber [
    self initialize.
    steps := aNumber.
    ^ self
]

{ #category : 'accessing' }
MoonWalkEffect >> steps [
    ^ steps
]

{ #category : 'accessing' }
MoonWalkEffect >> steps: aNumber [
    steps := aNumber
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships [
    self applyTo: aSpaceship inContextOf: allSpaceships inBoard: NullBoard new.
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
    allSpaceships do: [:ship | ship = aSpaceship ifFalse: [
        aBoard moveShip: ship backward: steps
    ]].
]
