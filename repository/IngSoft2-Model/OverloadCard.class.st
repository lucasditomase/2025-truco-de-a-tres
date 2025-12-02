Class {
    #name : 'OverloadCard',
    #superclass : 'PermanentCard',
    #instVars : [
        'targetShip'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
OverloadCard class >> forShip: aShip [
    ^ self new initializeForShip: (self ensureTargetShipFrom: aShip)
]

{ #category : 'validation' }
OverloadCard class >> ensureTargetShipFrom: aShip [
    (aShip isKindOf: Spaceship) ifFalse: [
        self error: 'Target ship must be a Spaceship instance'
    ].
    ^ aShip
]

{ #category : 'playing' }
OverloadCard >> activateFor: aShip inGame: aGame [
    targetShip addActiveCard: self
]

{ #category : 'initialization' }
OverloadCard >> initializeForShip: aShip [
    targetShip := self class ensureTargetShipFrom: aShip.
    ^ self
]

{ #category : 'accessing' }
OverloadCard >> targetShip [
    ^ targetShip
]

{ #category : 'effects' }
OverloadCard >> modifyRoll: aNumber forShip: aShip inGame: aGame [
    aShip = targetShip ifTrue: [ ^ aNumber - 2 ].
    ^ aNumber
]
