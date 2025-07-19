Class {
    #name : 'ReversedCardEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
ReversedCardEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    aSpaceship cards isEmpty ifTrue: [ ^ self ].
    aSpaceship removeCard: (aSpaceship cards atRandom).
]
