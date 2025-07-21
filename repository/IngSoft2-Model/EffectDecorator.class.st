Class {
    #name : 'EffectDecorator',
    #superclass : 'Object',
    #instVars : [
        'wrapped'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
EffectDecorator class >> new [
    ^ self basicNew initialize
]

{ #category : 'initialization' }
EffectDecorator >> initialize [
    wrapped := NullEffect new.
    ^ self
]

{ #category : 'operations' }
EffectDecorator >> applyEffectTo: aShip inBoard: aBoard [
]

{ #category : 'operations' }
EffectDecorator >> applyTo: aShip inContextOf: ships inBoard: aBoard [
    self applyTo: aShip inBoard: aBoard
]

{ #category : 'instance creation' }
EffectDecorator >> applyTo: aShip [
    | board |
    board := NullBoard new.
    self applyEffectTo: aShip inBoard: board.
    wrapped applyTo: aShip inBoard: board.
]

{ #category : 'instance creation' }
EffectDecorator >> applyTo: aShip inBoard: aBoard [
    | board |
    board := aBoard.
    self applyEffectTo: aShip inBoard: board.
    wrapped applyTo: aShip inBoard: board.
]

{ #category : 'instance creation' }
EffectDecorator >> decorate: anEffect [
    wrapped := anEffect.

    ^ self.
]

{ #category : 'instance creation' }
EffectDecorator >> wrapped [
    ^ wrapped
]

{ #category : 'operations' }
EffectDecorator >> reversed [
    ^ ReversedEffect of: self
]

{ #category : 'operations' }
EffectDecorator >> allowsEntryWithRoll: aRoll [
    ^ true
]
