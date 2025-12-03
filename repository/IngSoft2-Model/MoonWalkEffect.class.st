Class {
    #name : 'MoonWalkEffect',
    #superclass : 'EffectDecorator',
    #instVars : [
        'steps'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
MoonWalkEffect class >> withSteps: aNumber [
    ^ self new initializeWithSteps: (self ensureStepsFrom: aNumber)
]

{ #category : 'validation' }
MoonWalkEffect class >> ensureStepsFrom: aNumber [
    (aNumber isInteger and: [ aNumber > 0 ]) ifFalse: [
        self error: 'Steps must be a positive integer'
    ].
    ^ aNumber
]

{ #category : 'operations' }
MoonWalkEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    ^ self.
]

{ #category : 'initialization' }
MoonWalkEffect >> initialize [
    super initialize.
    steps := 2.
    ^ self
]

{ #category : 'initialization' }
MoonWalkEffect >> initializeWithSteps: aNumber [
    self initialize.
    steps := self class ensureStepsFrom: aNumber.
    ^ self
]

{ #category : 'accessing' }
MoonWalkEffect >> steps [
    ^ steps
]

{ #category : 'accessing' }
MoonWalkEffect >> steps: aNumber [
    steps := self class ensureStepsFrom: aNumber
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships [
    self applyTo: aSpaceship inContextOf: allSpaceships inBoard: NullBoard new.
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
    | originalPosition otherShips |
    originalPosition := self originalPositionFor: aSpaceship on: aBoard.
    otherShips := allSpaceships asArray
        select: [ :ship | ship ~~ aSpaceship ].
    otherShips do: [ :ship |
        aBoard moveShip: ship backward: steps
    ].
    self restore: aSpaceship to: originalPosition on: aBoard
]

{ #category : 'operations' }
MoonWalkEffect >> reversedVersion [
    ^ MoonWalkForwardEffect withSteps: self steps
]

{ #category : 'private' }
MoonWalkEffect >> originalPositionFor: aSpaceship on: aBoard [
    (aBoard respondsTo: #positionOf:) ifTrue: [
        ^ aBoard positionOf: aSpaceship
    ].
    ^ aSpaceship position
]

{ #category : 'private' }
MoonWalkEffect >> restore: aSpaceship to: aPosition on: aBoard [
    (aBoard respondsTo: #moveShip:to:) ifTrue: [
        ^ aBoard moveShip: aSpaceship to: aPosition
    ].
    aSpaceship moveTo: aPosition
]
