Class {
    #name : 'HyperGravityEffect',
    #superclass : 'EffectDecorator',
    #instVars : [
        'requiredRoll'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
HyperGravityEffect >> allowsEntryWithRoll: aNumber [
    ^ aNumber >= self requiredRoll
]

{ #category : 'operations' }
HyperGravityEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
]

{ #category : 'initialization' }
HyperGravityEffect >> initialize [
    super initialize.
    requiredRoll := NullRequiredRoll new.
]

{ #category : 'initialization' }
HyperGravityEffect >> requiredRoll [
    ^ requiredRoll value
]

{ #category : 'initialization' }
HyperGravityEffect >> requiredRoll: aNumber [
    (aNumber isInteger and: [ aNumber > 0 ]) ifFalse: [
        self error: 'Required roll must be a positive integer'.
    ].
    requiredRoll := RequiredRoll withValue: aNumber.
]

{ #category : 'configuration' }
HyperGravityEffect >> configureWithMaxRoll: maxRoll [
    requiredRoll isNullRequired ifTrue: [ self requiredRoll: maxRoll ]
]
