Class {
    #name : 'HyperGravityEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
HyperGravityEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
HyperGravityEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'asserting' }
HyperGravityEffectTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
HyperGravityEffectTest >> testHyperGravityBlocksEntryWithLowRoll [
    | scenario game ship deterministicDie effect |
    effect := HyperGravityEffect new.
    effect requiredRoll: 6.
    deterministicDie := DeterministicDie withValues: #(5).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 5 put: effect ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: ship inGame: game.
    game playTurn.
    
    self deny: ship position equals: 5.
]

{ #category : 'tests' }
HyperGravityEffectTest >> testHyperGravityAllowsEntryWithSufficientRoll [
    | scenario game ship deterministicDie effect |
    effect := HyperGravityEffect new.
    effect requiredRoll: 4.
    deterministicDie := DeterministicDie withValues: #(6).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 20;
        configureBoardWith: [ :board |
            board cells at: 6 put: effect ];
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    
    self ensureTurnOf: ship inGame: game.
    game playTurn.
    
    self assert: ship position equals: 6.
]

{ #category : 'tests' }
HyperGravityEffectTest >> testRequiredRollMustBePositiveInteger [
    | effect |
    effect := HyperGravityEffect new.
    self
        should: [ effect requiredRoll: 0 ]
        raise: Error
        withMessageText: 'Required roll must be a positive integer'.
    self
        should: [ effect requiredRoll: -1 ]
        raise: Error
        withMessageText: 'Required roll must be a positive integer'.
    effect requiredRoll: 7.
    self assert: effect requiredRoll equals: 7.
]
