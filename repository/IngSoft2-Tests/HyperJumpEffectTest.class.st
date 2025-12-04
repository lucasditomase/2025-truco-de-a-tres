Class {
    #name : 'HyperJumpEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
HyperJumpEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
HyperJumpEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'asserting' }
HyperJumpEffectTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
        self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
HyperJumpEffectTest >> testHyperJumpCyclesThroughValuesOnMultipleTriggers [
    | scenario game ship1 ship2 deterministicDie effect |
    effect := HyperJumpEffect withValues: #(1 2).
    deterministicDie := DeterministicDie withValues: #(3 3).
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 30;
        configureBoardWith: [ :aBoard |
            aBoard cells at: 3 put: effect ];
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    ship2 := scenario shipNamed: 'Beta'.
    
    self ensureTurnOf: ship1 inGame: game.
    game playTurn.
    
    self ensureTurnOf: ship2 inGame: game.
    game playTurn.
    
    self deny: ship1 position equals: ship2 position.
]

{ #category : 'tests' }
HyperJumpEffectTest >> testWithValuesRequiresNonEmptyCollection [
    self
        should: [ HyperJumpEffect withValues: #() ]
        raise: Error
        withMessageText: 'Hyper jump values must be a non-empty collection'.
]

{ #category : 'tests' }
HyperJumpEffectTest >> testWithLightYearValuesCreatesEffect [
    | effect |
    effect := HyperJumpEffect withLightYearValues: #(1 2 3).
    self assert: effect notNil.
    self assert: effect values size equals: 3.
]

{ #category : 'tests' }
HyperJumpEffectTest >> testApplyToRaisesErrorWithoutBoard [
    | effect ship |
    effect := HyperJumpEffect withValues: { Distance parsecs: 10 }.
    ship := Spaceship withName: 'TestShip'.
    
    self
        should: [ effect applyTo: ship ]
        raise: Error
        withMessageText: 'Use applyTo:inBoard: instead.'.
]

{ #category : 'tests' }
HyperJumpEffectTest >> testInitializeWithSortsValuesDescending [
    | effect values |
    effect := HyperJumpEffect withValues: { 
        Distance parsecs: 10 . 
        Distance parsecs: 30 . 
        Distance parsecs: 20 
    }.
    
    values := effect values.
    self assert: (values first) asParsecs >= (values second) asParsecs.
    self assert: (values second) asParsecs >= (values third) asParsecs.
]

{ #category : 'tests' }
HyperJumpEffectTest >> testInitializeSetsCurrentIndexToOne [
    | effect |
    effect := HyperJumpEffect withValues: { Distance parsecs: 10 }.
    self assert: effect currentIndex equals: 1.
]
