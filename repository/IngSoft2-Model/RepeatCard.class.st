Class {
    #name : 'RepeatCard',
    #superclass : 'InstantCard',
    #instVars : [ 'targetShip' ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
RepeatCard class >> targeting: aShip [
    ^ self new targetShip: aShip
]

{ #category : 'initialization' }
RepeatCard >> initialize [
    targetShip := NullSpaceship new.
    ^ self
]

{ #category : 'playing' }
RepeatCard >> applyEffectTo: aShip inGame: aGame [
    aGame repeatLastEffectOn: (self resolveTargetFor: aShip)
]

{ #category : 'accessing' }
RepeatCard >> targetShip [
    ^ targetShip
]

{ #category : 'accessing' }
RepeatCard >> targetShip: aShip [
    targetShip := aShip
]

{ #category : 'private' }
RepeatCard >> resolveTargetFor: aShip [
    ^ targetShip isNullShip
        ifTrue: [ aShip ]
        ifFalse: [ targetShip ]
]

{ #category : 'querying' }
RepeatCard >> recordsLastEffect [
    ^ false
]
