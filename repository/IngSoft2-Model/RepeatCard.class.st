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

{ #category : 'playing' }
RepeatCard >> applyEffectTo: aShip inGame: aGame [
    | target |
    target := targetShip ifNil: [ aShip ].
    aGame repeatLastEffectOn: target
]

{ #category : 'accessing' }
RepeatCard >> targetShip [
    ^ targetShip
]

{ #category : 'accessing' }
RepeatCard >> targetShip: aShip [
    targetShip := aShip
]
