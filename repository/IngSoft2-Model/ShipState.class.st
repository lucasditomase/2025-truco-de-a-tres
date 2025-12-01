Class {
    #name : 'ShipState',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'enumerating' }
ShipState >> whenPenalizedDo: penalizedBlock whenNormalDo: normalBlock [
    self subclassResponsibility.
]

{ #category : 'penalty' }
ShipState >> isPenalized [
    ^ self turnsRemaining > 0
]

{ #category : 'penalty' }
ShipState >> penalizeFor: aNumber [
    self subclassResponsibility.
]

{ #category : 'penalty' }
ShipState >> reducePenalty [
    ^ self
        whenPenalizedDo: [
            self error: 'Penalized states must override #reducePenalty'
        ]
        whenNormalDo: [ self ]
]

{ #category : 'penalty' }
ShipState >> turnsRemaining [
    ^ 0
]
