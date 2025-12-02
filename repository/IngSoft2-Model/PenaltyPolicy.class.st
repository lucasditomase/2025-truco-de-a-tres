Class {
    #name : 'PenaltyPolicy',
    #superclass : 'Object',
    #instVars : [
        'shipStatuses',
        'fuelRestorer'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
PenaltyPolicy class >> withStatuses: aDictionary restoreFuelWith: aBlock [
    ^ self new
        initializeWithStatuses: (self ensureStatusesFrom: aDictionary)
        restoreFuelWith: (self ensureFuelRestorerFrom: aBlock)
]

{ #category : 'validation' }
PenaltyPolicy class >> ensureFuelRestorerFrom: aBlock [
    (aBlock isKindOf: BlockClosure) ifFalse: [
        self error: 'Fuel restorer must be a block'
    ].
    ^ aBlock
]

{ #category : 'validation' }
PenaltyPolicy class >> ensureStatusesFrom: aDictionary [
    (aDictionary isKindOf: Dictionary) ifFalse: [
        self error: 'Ship statuses must be stored in a Dictionary'
    ].
    aDictionary valuesDo: [ :each |
        (each isKindOf: ShipStatus) ifFalse: [
            self error: 'Ship statuses must contain ShipStatus values'
        ]
    ].
    ^ aDictionary
]

{ #category : 'initialization' }
PenaltyPolicy >> initializeWithStatuses: aDictionary restoreFuelWith: aBlock [
    shipStatuses := self class ensureStatusesFrom: aDictionary.
    fuelRestorer := self class ensureFuelRestorerFrom: aBlock.
    ^ self
]

{ #category : 'penalties' }
PenaltyPolicy >> penalize: aShip forTurns: turns [
    aShip penalizeFor: turns.
    (self statusFor: aShip) penalized: true
]

{ #category : 'penalties' }
PenaltyPolicy >> reducePenaltyFor: aShip [
    aShip reducePenalty.
    (self statusFor: aShip) penalized: aShip isPenalized.
    fuelRestorer value: aShip
]

{ #category : 'private' }
PenaltyPolicy >> statusFor: aShip [
    ^ shipStatuses at: aShip
]
