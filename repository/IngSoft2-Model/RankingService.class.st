Class {
    #name : 'RankingService',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'ranking' }
RankingService >> rankingFor: someStatuses [
    ^ someStatuses sort: [ :first :second | self compare: first with: second ]
]

{ #category : 'ranking' }
RankingService >> compare: firstStatus with: secondStatus [
    | sameLaps samePosition |
    sameLaps := firstStatus lapCount = secondStatus lapCount.
    samePosition := firstStatus position = secondStatus position.

    ^ sameLaps
        ifTrue: [
            samePosition
                ifTrue: [ firstStatus ship name < secondStatus ship name ]
                ifFalse: [ firstStatus position > secondStatus position ] ]
        ifFalse: [ firstStatus lapCount > secondStatus lapCount ]
]
