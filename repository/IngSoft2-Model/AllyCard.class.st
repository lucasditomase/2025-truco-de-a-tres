Class {
    #name : 'AllyCard',
    #superclass : 'PermanentCard',
    #instVars : [
        'allyShip',
        'ownerShip'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
AllyCard class >> withAlly: aShip [
    ^ self new initializeWithAlly: aShip
]

{ #category : 'playing' }
AllyCard >> activateFor: aShip inGame: aGame [
    ownerShip := aShip.
    ownerShip addActiveCard: self.
    allyShip addActiveCard: self
]

{ #category : 'ally' }
AllyCard >> allyFor: aShip [
    aShip = ownerShip ifTrue: [ ^ allyShip ].
    aShip = allyShip ifTrue: [ ^ ownerShip ].
    ^ NullSpaceship new
]

{ #category : 'initialization' }
AllyCard >> initializeWithAlly: aShip [
    allyShip := aShip.
    ^ self
]

{ #category : 'accessing' }
AllyCard >> allyShip [
    ^ allyShip
]

{ #category : 'accessing' }
AllyCard >> ownerShip [
    ^ ownerShip
]
