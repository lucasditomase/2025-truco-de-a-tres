Class {
    #name : 'ReversalCard',
    #superclass : 'PermanentCard',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'playing' }
ReversalCard >> activateFor: aShip inGame: aGame [
    | position board |
    board := aGame board.
    position := board positionOf: aShip.
    board reverseAt: position.
]
