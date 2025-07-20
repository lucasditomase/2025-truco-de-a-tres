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
    | ships steps parsecs |
    original class = BlackHoleEffect ifTrue: [
        aBoard moveShip: aShip forward: 4.
        ^ self ].
    original class = HyperGravityEffect ifTrue: [
        "Reversing HyperGravity has no positional effect once the ship is on the
        cell, therefore nothing happens."
        ^ self ].
    original class = HyperJumpEffect ifTrue: [
        aBoard moveShip: aShip to: aShip position.
        parsecs := original nextJumpValue.
        steps := (parsecs / aBoard totalLengthInParsecs * aBoard cellCount) rounded.
        aBoard moveShip: aShip backward: steps.
        ^ self ].
    original class = MoonWalkEffect ifTrue: [
        ships := aBoard ships.
        ships do: [:ship | ship = aShip ifFalse: [ aBoard moveShip: ship forward: original steps ]].
        ^ self ].
    original class = CardEffect ifTrue: [
        (aShip cards isEmpty) ifFalse: [ aShip cards removeAt: (1 to: aShip cards size) atRandom ].
        ^ self ].
    ^ self
]

{ #category : 'instance creation' }
ReversedEffect >> applyTo: aShip [
    self applyTo: aShip inBoard: NullBoard new
]

{ #category : 'instance creation' }
ReversedEffect >> applyTo: aShip inBoard: aBoard [
    self applyEffectTo: aShip inBoard: aBoard.
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> reversed [
    ^ original
]
