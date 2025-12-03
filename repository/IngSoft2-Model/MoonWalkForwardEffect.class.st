Class {
    #name : 'MoonWalkForwardEffect',
    #superclass : 'MoonWalkEffect',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
MoonWalkForwardEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
    allSpaceships asArray do: [ :ship |
        ship == aSpaceship ifFalse: [
            aBoard moveShip: ship forward: self steps
        ]
    ].
]
