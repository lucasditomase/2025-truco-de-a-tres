Class {
    #name : 'ShipStatus',
    #superclass : 'Object',
    #instVars : [
        'ship',
        'position',
        'lapCount',
        'penalized'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
ShipStatus class >> for: aShip position: aPosition laps: aLapCount penalized: isPenalized [
    ^ self new
        initializeWith: (self ensureShipFrom: aShip)
        position: (self ensurePositionFrom: aPosition)
        laps: (self ensureLapCountFrom: aLapCount)
        penalized: (self ensurePenaltyFlagFrom: isPenalized).
]

{ #category : 'validation' }
ShipStatus class >> ensureLapCountFrom: aLapCount [
    (aLapCount isInteger and: [ aLapCount >= 0 ]) ifFalse: [
        self error: 'Lap count must be a non-negative integer'
    ].
    ^ aLapCount
]

{ #category : 'validation' }
ShipStatus class >> ensurePenaltyFlagFrom: aFlag [
    (aFlag isKindOf: Boolean) ifFalse: [
        self error: 'Penalized flag must be a Boolean'
    ].
    ^ aFlag
]

{ #category : 'validation' }
ShipStatus class >> ensurePositionFrom: aPosition [
    (aPosition isInteger and: [ aPosition >= 0 ]) ifFalse: [
        self error: 'Position must be a non-negative integer'
    ].
    ^ aPosition
]

{ #category : 'validation' }
ShipStatus class >> ensureShipFrom: aShip [
    (aShip isKindOf: Spaceship) ifFalse: [
        self error: 'Ship must be a Spaceship instance'
    ].
    ^ aShip
]

{ #category : 'updating' }
ShipStatus >> addLap [
    lapCount := lapCount + 1
]

{ #category : 'methods' }
ShipStatus >> removeLap [
    lapCount := (lapCount - 1) max: 0
]

{ #category : 'accessing' }
ShipStatus >> hasWonWithTotalLaps: aNumber [
    ^ lapCount >= aNumber
]

{ #category : 'initialization' }
ShipStatus >> initializeWith: aShip position: aPosition laps: aLapCount penalized: isPenalized [
    ship := self class ensureShipFrom: aShip.
    position := self class ensurePositionFrom: aPosition.
    lapCount := self class ensureLapCountFrom: aLapCount.
    penalized := self class ensurePenaltyFlagFrom: isPenalized
]

{ #category : 'accessing' }
ShipStatus >> isPenalized [
    ^ penalized
]

{ #category : 'accessing' }
ShipStatus >> lapCount [
    ^ lapCount
]

{ #category : 'accessing' }
ShipStatus >> penalized: aBoolean [
    penalized := aBoolean
]

{ #category : 'accessing' }
ShipStatus >> position [
    ^ position
]

{ #category : 'accessing' }
ShipStatus >> position: aPosition [
    position := aPosition
]

{ #category : 'accessing' }
ShipStatus >> ship [
    ^ ship
]
