Class {
    #name : 'AtomicBombEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
AtomicBombEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    aBoard ifNil: [ ^ self ].
    (aBoard respondsTo: #ships) ifFalse: [ ^ self ].
    aBoard ships do: [:ship | aBoard moveShipWithoutFuel: ship to: 0 ].
]

{ #category : 'operations' }
AtomicBombEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
    | board |
    board := aBoard ifNil: [ NullBoard new ] ifNotNil: [ aBoard ].
    allSpaceships do: [:ship |
        board moveShip: ship to: 0
    ].
]
