Class {
    #name : 'ReversedMoonWalkEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
ReversedMoonWalkEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    ^ self
]

{ #category : 'operations' }
ReversedMoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
    | board |
    board := aBoard ifNil: [ NullBoard new ] ifNotNil: [ aBoard ].
    allSpaceships do: [:ship | ship = aSpaceship ifFalse: [
        board moveShip: ship forward: 2
    ]].
]
