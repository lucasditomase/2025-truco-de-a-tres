Class {
    #name : 'NullEffect',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
NullEffect >> applyTo: aShip inBoard: aBoard [
    NullBehavior doNothing
]

{ #category : 'operations' }
NullEffect >> applyEffectTo: aShip inBoard: aBoard [
    self applyTo: aShip inBoard: aBoard
]

{ #category : 'operations' }
NullEffect >> applyTo: aShip inContextOf: ships inBoard: aBoard [
    self applyTo: aShip inBoard: aBoard.
    ^ self
]

{ #category : 'operations' }
NullEffect >> allowsEntryWithRoll: aRoll [
    ^ NullBehavior alwaysTrue
]

{ #category : 'operations' }
NullEffect >> reversed [
    ^ NullBehavior passThrough: self
]

{ #category : 'querying' }
NullEffect >> consumesFuel [
    ^ true
]

{ #category : 'converting' }
NullEffect >> asBoardEffect [
    ^ self
]

