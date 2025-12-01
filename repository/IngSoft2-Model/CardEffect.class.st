Class {
    #name : 'CardEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
CardEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    aSpaceship addCard: (aBoard drawCard).
]

{ #category : 'operations' }
CardEffect >> reversedVersion [
    ^ BlockEffect on: [ :ship :board |
        (ship cards isEmpty) ifFalse: [
            ship cards removeAt: (1 to: ship cards size) atRandom
        ]
    ]
]
