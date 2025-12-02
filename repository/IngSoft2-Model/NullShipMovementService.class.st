Class {
    #name : 'NullShipMovementService',
    #superclass : 'ShipMovementService',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
NullShipMovementService >> initialize [
    positionManager := NullPositionManager new.
    cellCount := 0.
    lastMoves := Dictionary new.
    recentMoves := Dictionary new.
    recordingMoves := false.
    ^ self
]
