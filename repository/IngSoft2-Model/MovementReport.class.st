Class {
    #name : 'MovementReport',
    #superclass : 'Object',
    #instVars : [
        'startPosition',
        'delta'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
MovementReport class >> startingAt: aStart delta: aDelta [
    ^ self new initializeStartingAt: aStart delta: aDelta
]

{ #category : 'initialization' }
MovementReport >> initializeStartingAt: aStart delta: aDelta [
    startPosition := aStart.
    delta := aDelta.
    ^ self
]

{ #category : 'updating' }
MovementReport >> addDelta: aDelta [
    delta := delta + aDelta
]

{ #category : 'accessing' }
MovementReport >> copy [
    ^ MovementReport startingAt: startPosition delta: delta
]

{ #category : 'accessing' }
MovementReport >> delta [
    ^ delta
]

{ #category : 'accessing' }
MovementReport >> startPosition [
    ^ startPosition
]
