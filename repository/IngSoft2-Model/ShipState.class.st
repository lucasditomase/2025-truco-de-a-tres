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
    self subclassResponsibility.
]

{ #category : 'penalty' }
ShipState >> penalizeFor: aNumber [
    self subclassResponsibility.
]

{ #category : 'penalty' }
ShipState >> reducePenalty [
    self subclassResponsibility.
]

{ #category : 'penalty' }
ShipState >> turnsRemaining [
    self subclassResponsibility.
]
