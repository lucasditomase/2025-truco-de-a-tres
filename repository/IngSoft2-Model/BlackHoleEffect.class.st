Class {
    #name : 'BlackHoleEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
BlackHoleEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    aBoard moveShip: aSpaceship backward: 4.
]
