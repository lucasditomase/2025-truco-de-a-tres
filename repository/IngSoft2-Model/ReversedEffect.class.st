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
    original class = BlackHoleEffect ifTrue: [ ^ self reverseBlackHoleOn: aShip inBoard: aBoard ].
    original class = HyperGravityEffect ifTrue: [ ^ self ].
    original class = HyperJumpEffect ifTrue: [ ^ self reverseHyperJumpOn: aShip inBoard: aBoard ].
    original class = MoonWalkEffect ifTrue: [ ^ self reverseMoonWalkOn: aShip inBoard: aBoard ].
    original class = CardEffect ifTrue: [ ^ self reverseCardEffectOn: aShip ].
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> reverseBlackHoleOn: aShip inBoard: aBoard [
    aBoard moveShip: aShip forward: 4.
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> reverseHyperJumpOn: aShip inBoard: aBoard [
    | parsecs steps |
    aBoard moveShip: aShip to: aShip position.
    parsecs := original nextJumpValue.
    steps := (parsecs / aBoard totalLengthInParsecs * aBoard cellCount) rounded.
    aBoard moveShip: aShip backward: steps.
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> reverseMoonWalkOn: aShip inBoard: aBoard [
    | ships |
    ships := aBoard ships.
    ships do: [ :ship | ship = aShip ifFalse: [ aBoard moveShip: ship forward: original steps ] ].
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> reverseCardEffectOn: aShip [
    (aShip cards isEmpty) ifFalse: [
        aShip cards removeAt: (1 to: aShip cards size) atRandom
    ].
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
