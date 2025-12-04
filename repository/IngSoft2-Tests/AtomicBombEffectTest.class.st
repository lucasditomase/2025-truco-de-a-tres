Class {
    #name : 'AtomicBombEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
AtomicBombEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
AtomicBombEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

