Class {
    #name : 'TimeMachineCard',
    #superclass : 'InstantCard',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'playing' }
TimeMachineCard >> applyEffectTo: aShip inGame: aGame [
    | ships |
    ships := OrderedCollection with: aShip.
    ships addAll: aShip allies.

    ships do: [ :ship |
        (aGame fuelHistoryFor: ship) size >= 2
            ifFalse: [ self error: 'Not enough turns to use Time Machine' ] ].

    ships do: [ :ship |
        ship fuel: ((aGame fuelHistoryFor: ship) first) ]
]

