Class {
    #name : 'BlockEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
BlockEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
BlockEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'asserting' }
BlockEffectTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
BlockEffectTest >> testBlockEffectExecutesActionWhenShipLandsOnCell [
    | scenario game ship deterministicDie effect |
    effect := BlockEffect on: [ :aShip :aBoard | aBoard moveShip: aShip forward: 2 ].
    deterministicDie := DeterministicDie withValues: #(4).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        withEffect: effect at: 4;
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: ship inGame: game.
    game playTurn.
    
    self assert: ship position equals: 6.
]

{ #category : 'tests' }
BlockEffectTest >> testOnRequiresBlockClosure [
    self
        should: [ BlockEffect on: 'not a block' ]
        raise: Error
        withMessageText: 'Block effect action must be a block that takes two arguments'.
]

{ #category : 'tests' }
BlockEffectTest >> testOnRequiresBlockWithTwoArguments [
    self
        should: [ BlockEffect on: [ :ship | ship moveForward: 1 ] ]
        raise: Error
        withMessageText: 'Block effect action must be a block that takes two arguments'.
]
