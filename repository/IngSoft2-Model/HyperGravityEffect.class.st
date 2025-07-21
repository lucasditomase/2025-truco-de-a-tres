Class {
    #name : 'HyperGravityEffect',
    #superclass : 'EffectDecorator',
    #instVars : [
        'requiredRoll'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
HyperGravityEffect >> allowsEntryWithRoll: aNumber [
    ^ aNumber >= requiredRoll
]

{ #category : 'operations' }
HyperGravityEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    "HyperGravity only restricts movement based on the dice roll. Once the ship
    has reached this cell the effect does not alter its position."
    ^ aSpaceship.
]

{ #category : 'initialization' }
HyperGravityEffect >> initialize [
    super initialize.
    requiredRoll := 4.
]

{ #category : 'initialization' }
HyperGravityEffect >> requiredRoll [
    ^ requiredRoll
]

{ #category : 'initialization' }
HyperGravityEffect >> requiredRoll: aNumber [
    aNumber > 12 ifTrue: [
        self error: 'Required roll cannot exceed dice maximum'.
    ].
    requiredRoll := aNumber.
]
