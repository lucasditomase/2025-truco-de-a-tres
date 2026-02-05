Class {
    #name : 'TimeMachineCard',
    #superclass : 'InstantCard',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'playing' }
TimeMachineCard >> applyEffectTo: aShip inGame: aGame [
    aGame applyTimeMachineTo: aShip
]

