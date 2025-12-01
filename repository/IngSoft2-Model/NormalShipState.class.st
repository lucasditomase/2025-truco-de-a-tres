Class {
    #name : 'NormalShipState',
    #superclass : 'ShipState',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'penalty' }
NormalShipState >> penalizeFor: aNumber [
    ^ PenalizedShipState forTurns: aNumber
]

{ #category : 'enumerating' }
NormalShipState >> whenPenalizedDo: penalizedBlock whenNormalDo: normalBlock [
    ^ normalBlock value
]

