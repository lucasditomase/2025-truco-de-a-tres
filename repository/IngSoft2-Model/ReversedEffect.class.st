Class {
    #name : 'ReversedEffect',
    #superclass : 'EffectDecorator',
    #instVars : ['original'],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
ReversedEffect class >> of: anEffect [
    ^ self new initializeWith: anEffect
]

{ #category : 'initialization' }
ReversedEffect >> initializeWith: anEffect [
    original := anEffect.
    self decorate: anEffect.
    ^ self
]

{ #category : 'accessing' }
ReversedEffect >> original [
    ^ original
]

{ #category : 'operations' }
ReversedEffect >> applyEffectTo: aShip inBoard: aBoard [
    | board ships steps parsecs |
    board := aBoard ifNil: [ NullBoard new ] ifNotNil: [ aBoard ].
    original class = BlackHoleEffect ifTrue: [
        board moveShip: aShip forward: 4.
        ^ self ].
    original class = HyperGravityEffect ifTrue: [
        board moveShip: aShip forward: 1.
        ^ self ].
    original class = HyperJumpEffect ifTrue: [
        board moveShip: aShip to: aShip position.
        parsecs := original nextJumpValue.
        steps := (parsecs / board totalLengthInParsecs * board cellCount) rounded.
        board moveShip: aShip backward: steps.
        ^ self ].
    original class = MoonWalkEffect ifTrue: [
        ships := board ships.
        ships do: [:ship | ship = aShip ifFalse: [ board moveShip: ship forward: 2 ]].
        ^ self ].
    original class = CardEffect ifTrue: [
        (aShip cards isEmpty) ifFalse: [ aShip cards removeAt: (1 to: aShip cards size) atRandom ].
        ^ self ].
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> applyTo: aShip [
    self applyTo: aShip inBoard: nil
]

{ #category : 'operations' }
ReversedEffect >> applyTo: aShip inBoard: aBoard [
    | board |
    board := aBoard ifNil: [ NullBoard new ] ifNotNil: [ aBoard ].
    self applyEffectTo: aShip inBoard: board.
    ^ self
]
