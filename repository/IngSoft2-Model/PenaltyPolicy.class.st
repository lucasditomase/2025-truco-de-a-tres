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
    ^ self new initializeWithStatuses: aDictionary restoreFuelWith: aBlock
]

{ #category : 'initialization' }
PenaltyPolicy >> initializeWithStatuses: aDictionary restoreFuelWith: aBlock [
    shipStatuses := aDictionary.
    fuelRestorer := aBlock.
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
