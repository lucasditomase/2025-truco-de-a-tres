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
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> applyTo: aShip inContextOf: ships inBoard: aBoard [
    ^ self
        applyReversedTo: aShip
        inContextOf: ships
        inBoard: aBoard
]

{ #category : 'instance creation' }
ReversedEffect >> applyTo: aShip [
    self applyTo: aShip inBoard: NullBehavior temporaryBoard
]

{ #category : 'instance creation' }
ReversedEffect >> applyTo: aShip inBoard: aBoard [
    | participants |
    participants := (aBoard respondsTo: #ships)
        ifTrue: [ aBoard ships ]
        ifFalse: [ { aShip } ].
    ^ self
        applyReversedTo: aShip
        inContextOf: participants
        inBoard: aBoard
]

{ #category : 'private' }
ReversedEffect >> applyReversedTo: aShip inContextOf: ships inBoard: aBoard [
    | reversed |
    reversed := original reversedVersion.
    reversed applyTo: aShip inContextOf: ships inBoard: aBoard.
    ^ self
]

{ #category : 'operations' }
ReversedEffect >> reversed [
    ^ original
]
