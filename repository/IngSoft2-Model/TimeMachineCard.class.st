Class {
    #name : 'TimeMachineCard',
    #superclass : 'InstantCard',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'playing' }
TimeMachineCard >> applyEffectTo: aShip inGame: aGame [
    | targets |
    targets := OrderedCollection with: aShip.
    aShip activeCards do: [ :card |
        card isKindOf: AllyCard ifTrue: [
            | ally |
            ally := card allyFor: aShip.
            ally ifNotNil: [ targets add: ally ].
        ] ].
    (targets anySatisfy: [ :ship | (aGame turnsPlayedFor: ship) < 3 ])
        ifTrue: [ self error: 'Cannot use Time Machine yet' ].
    targets do: [ :ship |
        | history index |
        history := aGame fuelHistoryFor: ship.
        index := history size - 2.
        ship instVarNamed: 'fuel' put: (history at: index) ].
]
