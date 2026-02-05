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


{ #category : 'configuration' }
HyperGravityEffect >> configureWithMaxRoll: maxRoll [
    requiredRoll isNullRequired ifTrue: [ requiredRoll := RequiredRoll withValue: maxRoll ]
]
