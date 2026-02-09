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

{ #category : 'validation' }
AllyCard class >> ensureAllyFrom: aShip [
    ^ Spaceship ensureSpaceship: aShip errorMessage: 'Ally must be a Spaceship instance'
]

{ #category : 'initialization' }
AllyCard class >> withAlly: aShip [
    ^ self new initializeWithAlly: (self ensureAllyFrom: aShip)
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
    allyShip := self class ensureAllyFrom: aShip.
    ^ self
]

{ #category : 'accessing' }
AllyCard >> allyShip [
    ^ allyShip
]

{ #category : 'accessing' }
AllyCard >> allyShip: aShip [
    allyShip := aShip
]

{ #category : 'accessing' }
AllyCard >> ownerShip [
    ^ ownerShip
]
