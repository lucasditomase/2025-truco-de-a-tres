Class {
    #name : 'AtomicBombEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
AtomicBombEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    self applyTo: aSpaceship inContextOf: aBoard ships inBoard: aBoard
]

{ #category : 'operations' }
AtomicBombEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
    allSpaceships asArray do: [:ship |
        aBoard moveShip: ship to: 0
    ].
]

{ #category : 'querying' }
AtomicBombEffect >> consumesFuel [
    ^ false
]

{ #category : 'querying' }
AtomicBombEffect >> canBeReversed [
    ^ false
]
