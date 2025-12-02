Extension {
    #name : 'Object'
}

{ #category : '*IngSoft2-Model' }
Object >> asBlockEffectAction [
    self error: BlockEffect invalidActionMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asBoardDistance [
    self error: Board invalidDistanceMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asMovementHistoryDictionaryWithMessage: errorMessage [
    self error: errorMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asPositionManagerWithMessage: errorMessage [
    self error: errorMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asFuelRestorer [
    self error: PenaltyPolicy invalidFuelRestorerMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asShipStatusRegistry [
    self error: PenaltyPolicy invalidStatusRegistryMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asShipStatusWithMessage: errorMessage [
    self error: errorMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asPenaltyFlagWithMessage: errorMessage [
    self error: errorMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asSpaceshipCollection [
    self error: Spaceship invalidCollectionMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asSpaceshipWithMessage: errorMessage [
    self error: errorMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asGameBoard [
    self error: Game invalidBoardMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asDiceCupForGame [
    self error: Game invalidDiceMessage
]

{ #category : '*IngSoft2-Model' }
Object >> asBoardEffect [
    self error: Board invalidEffectMessage
]
