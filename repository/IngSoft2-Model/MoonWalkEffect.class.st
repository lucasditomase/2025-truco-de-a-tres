Class {
    #name : 'MoonWalkEffect',
    #superclass : 'EffectDecorator',
    #instVars : [
        'stepsBack'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
MoonWalkEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
        ^ self.
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships [
    self applyTo: aSpaceship inContextOf: allSpaceships inBoard: nil.
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
        | board |
        board := aBoard ifNil: [ NullBoard new ] ifNotNil: [ aBoard ].
        allSpaceships do: [:ship | ship = aSpaceship ifFalse: [
            board moveShip: ship backward: stepsBack
        ]].
]

{ #category : 'initialization' }
MoonWalkEffect class >> withSteps: aNumber [
    ^ self new initializeWithSteps: aNumber
]

{ #category : 'initialization' }
MoonWalkEffect >> initialize [
    super initialize.
    stepsBack := 2.
]

{ #category : 'initialization' }
MoonWalkEffect >> initializeWithSteps: aNumber [
    self initialize.
    stepsBack := aNumber.
    ^ self
]

{ #category : 'accessing' }
MoonWalkEffect >> stepsBack [
    ^ stepsBack
]
