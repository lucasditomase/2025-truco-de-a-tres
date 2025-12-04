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

{ #category : 'tests' }
AtomicBombEffectTest >> testApplyEffectToDelegatesToApplyToInContextOf [
    | effect ship board |
    effect := AtomicBombEffect new.
    ship := Spaceship withName: 'TestShip'.
    board := Board of: 10 andWormholeAt: #().
    
    ship moveTo: 5.
    
    effect applyEffectTo: ship inBoard: board.
    
    "All ships should be moved to position 0"
    self assert: ship position equals: 0.
]

