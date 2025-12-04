Class {
    #name : 'MoonWalkForwardEffect',
    #superclass : 'MoonWalkEffect',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
MoonWalkForwardEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
    | originalPosition |
    originalPosition := self originalPositionFor: aSpaceship on: aBoard.
    allSpaceships do: [ :ship |
        ship == aSpaceship ifFalse: [
            aBoard moveShip: ship forward: self steps
        ]
    ].
    self restore: aSpaceship to: originalPosition on: aBoard
]
