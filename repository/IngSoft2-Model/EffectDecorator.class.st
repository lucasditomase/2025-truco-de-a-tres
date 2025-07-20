Class {
    #name : 'EffectDecorator',
    #superclass : 'Object',
    #instVars : [
        'wrapped'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
EffectDecorator class >> new [
    ^ super new initialize
]

{ #category : 'initialization' }
EffectDecorator >> initialize [
    wrapped := NullEffect new.
    ^ self
]

{ #category : 'operations' }
EffectDecorator >> applyEffectTo: aShip inBoard: aBoard [
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
