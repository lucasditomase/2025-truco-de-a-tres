Class {
    #name : 'ReversedBlackHoleEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
ReversedBlackHoleEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    | board |
    board := aBoard ifNil: [ NullBoard new ] ifNotNil: [ aBoard ].
    board moveShip: aSpaceship forward: 4.
]
