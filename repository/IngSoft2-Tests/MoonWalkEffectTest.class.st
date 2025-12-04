Class {
    #name : 'MoonWalkEffectTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
MoonWalkEffectTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
MoonWalkEffectTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
MoonWalkEffectTest >> testWithStepsRequiresPositiveInteger [
    self
        should: [ MoonWalkEffect withSteps: 0 ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Steps must be a positive integer' ].
    self
        should: [ MoonWalkEffect withSteps: 'two' ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Steps must be a positive integer' ].
]

{ #category : 'tests' }
MoonWalkEffectTest >> testApplyEffectToReturnsSelf [
    | effect ship board |
    effect := MoonWalkEffect withSteps: 2.
    ship := Spaceship withName: 'TestShip'.
    board := Board of: 10 andWormholeAt: #().
    
    self assert: (effect applyEffectTo: ship inBoard: board) equals: effect.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testStepsSetterUpdatesSteps [
    | effect |
    effect := MoonWalkEffect withSteps: 2.
    self assert: effect steps equals: 2.
    
    effect steps: 5.
    self assert: effect steps equals: 5.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testApplyToWithoutBoardUsesNullBoard [
    | effect ship1 ship2 allShips |
    effect := MoonWalkEffect withSteps: 2.
    ship1 := Spaceship withName: 'Ship1'.
    ship2 := Spaceship withName: 'Ship2'.
    ship1 moveTo: 5.
    ship2 moveTo: 5.
    allShips := { ship1 . ship2 }.
    
    effect applyTo: ship1 inContextOf: allShips.
    
    
    self assert: ship1 position equals: 5.
    self assert: ship2 position equals: 3.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testShouldUseBoardMoveReturnsFalseWhenBoardDoesNotRespondToMoveShipTo [
    | effect board position result |
    effect := MoonWalkEffect withSteps: 2.
    board := Object new.
    position := 5.
    
    result := effect shouldUseBoardMoveFor: position on: board.
    
    self deny: result.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testShouldUseBoardMoveReturnsTrueWhenBoardDoesNotRespondToCellCount [
    | effect board position result |
    effect := MoonWalkEffect withSteps: 2.
    board := NullBoard new.
    position := 5.
    
    result := effect shouldUseBoardMoveFor: position on: board.
    
    self assert: result.
]

{ #category : 'tests' }
MoonWalkEffectTest >> testShouldUseBoardMoveReturnsTrueForValidPosition [
    | effect board result |
    effect := MoonWalkEffect withSteps: 2.
    board := Board of: 10 andWormholeAt: #().
    
    
    result := effect shouldUseBoardMoveFor: 5 on: board.
    self assert: result.
    
    
    result := effect shouldUseBoardMoveFor: 0 on: board.
    self assert: result.
    
    
    result := effect shouldUseBoardMoveFor: 9 on: board.
    self assert: result.
]
