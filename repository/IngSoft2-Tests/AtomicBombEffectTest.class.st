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
    board registerShips: { ship }.
    
    effect applyEffectTo: ship inBoard: board.
    
    
    self assert: ship position equals: 0.
]

{ #category : 'tests' }
AtomicBombEffectTest >> testApplyEffectToMovesAllShipsToZero [
    | effect ship1 ship2 board |
    effect := AtomicBombEffect new.
    ship1 := Spaceship withName: 'Ship1'.
    ship2 := Spaceship withName: 'Ship2'.
    board := Board of: 10 andWormholeAt: #().
    
    
    board registerShips: { ship1 . ship2 }.
    
    
    board moveShip: ship1 to: 5.
    board moveShip: ship2 to: 7.
    
    effect applyEffectTo: ship1 inBoard: board.
    
    
    self assert: (board positionOf: ship1) equals: 0.
    self assert: (board positionOf: ship2) equals: 0.
]

