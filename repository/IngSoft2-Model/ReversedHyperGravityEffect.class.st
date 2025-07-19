Class {
    #name : 'ReversedHyperGravityEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
ReversedHyperGravityEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    aBoard
        ifNil: [ aSpaceship moveForward: 1 ]
        ifNotNil: [ aBoard moveShip: aSpaceship forward: 1 ].
    ^ aSpaceship
]
