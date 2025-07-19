Class {
    #name : 'ReversalCard',
    #superclass : 'PermanentCard',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'playing' }
ReversalCard >> activateFor: aShip inGame: aGame [
    | position |
    position := aGame board positionOf: aShip.
    aGame board reverseCellAt: position.
]
