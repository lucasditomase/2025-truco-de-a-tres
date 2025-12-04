Class {
    #name : 'NullCard',
    #superclass : 'Card',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'playing' }
NullCard >> playOn: aShip inGame: aGame [
    NullBehavior doNothing
]

{ #category : 'querying' }
NullCard >> isNull [
    ^ true
]
