Class {
    #name : 'NullEffect',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
NullEffect >> applyTo: aShip inBoard: aBoard [
]

{ #category : 'operations' }
NullEffect >> applyTo: aShip inContextOf: ships inBoard: aBoard [
    ^ self
]

{ #category : 'operations' }
NullEffect >> allowsEntryWithRoll: aRoll [
    ^ true
]

{ #category : 'operations' }
NullEffect >> reversed [
    ^ self
]

