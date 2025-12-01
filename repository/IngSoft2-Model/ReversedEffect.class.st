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
    | reversed |
    reversed := original reversedVersion.
    reversed applyEffectTo: aShip inBoard: aBoard.
    ^ self
]

{ #category : 'instance creation' }
ReversedEffect >> applyTo: aShip [
    self applyTo: aShip inBoard: NullBehavior temporaryBoard
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
