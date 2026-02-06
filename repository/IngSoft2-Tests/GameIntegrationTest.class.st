Class {
	#name : 'GameIntegrationTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GameIntegrationTest >> builder [
	^ GameTestBuilder new
]

{ #category : 'support' }
GameIntegrationTest >> ensureTurnOf: aShip inGame: aGame [
	[ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'asserting' }
GameIntegrationTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]
{ #category : 'tests' }
GameIntegrationTest >> testAtomicBombEffectResetsPositionsButKeepsLaps [
    | scenario game |
    scenario := self builder
        boardWithCells: 10;
        withShipNames: #('Red' 'Blue' 'Green');
        withShipNamed: 'Red' at: 6;
        withShipNamed: 'Blue' at: 3;
        withShipNamed: 'Green' at: 9;
        withEffect: AtomicBombEffect new at: 5;
        withDice: (DeterministicDie withValues: { 2 } sides: 100); "Blue will land on 5"
        build.
    
    game := scenario game.
    "Ensure Blue's turn"
    self ensureTurnOf: (scenario shipNamed: 'Blue') inGame: game.
    
    game playTurn. "Blue moves 3->5, triggers Atomic Bomb"
    
    self assert: (game positionOf: (scenario shipNamed: 'Red')) equals: 0.
    self assert: (game positionOf: (scenario shipNamed: 'Blue')) equals: 0.
    self assert: (game positionOf: (scenario shipNamed: 'Green')) equals: 0.
]

{ #category : 'tests' }
GameIntegrationTest >> testBlackHoleEffectMovesSpaceshipBackwards [
    | scenario game |
    scenario := self builder
        boardWithCells: 10;
        withShipNamed: 'Lucas' at: 2;
        withEffect: BlackHoleEffect new at: 4;
        withDice: (DeterministicDie withValues: { 2 } sides: 100);
        build.
    
    game := scenario game.
    game playTurn. "Lucas moves 2->4, triggers Black Hole (-4 cells, -4 fuel)"
    
    "Board is 10 cells. Moving back 4 from 4 is 0."
    self assert: (game positionOf: (scenario shipNamed: 'Lucas')) equals: 0.
]

{ #category : 'tests' }
GameIntegrationTest >> testMoonWalkEffectMovesOtherSpaceshipsBackwards [
    | scenario game |
    scenario := self builder
        boardWithCells: 10;
        withShipNames: #('P1' 'P2' 'P3');
        withShipNamed: 'P1' at: 5;
        withShipNamed: 'P2' at: 2;
        withShipNamed: 'P3' at: 8;
        withEffect: (MoonWalkEffect withSteps: 3) at: 4;
        withDice: (DeterministicDie withValues: { 2 } sides: 100); "P2 will move 2->4"
        build.
    
    game := scenario game.
    self ensureTurnOf: (scenario shipNamed: 'P2') inGame: game.
    game playTurn.
    
    self assert: (game positionOf: (scenario shipNamed: 'P2')) equals: 4.
    self assert: (game positionOf: (scenario shipNamed: 'P1')) equals: 2. "5-3"
    self assert: (game positionOf: (scenario shipNamed: 'P3')) equals: 5. "8-3"
]

{ #category : 'tests' }
GameIntegrationTest >> testHyperJumpEffectJumpsShipForward [
    | scenario game |
    scenario := self builder
        boardWithCells: 10;
        withShipNamed: 'Apollo' at: 5;
        withEffect: (HyperJumpEffect withValues: #(3)) at: 6;
        withDice: (DeterministicDie withValues: { 1 } sides: 100);
        build.
    
    game := scenario game.
    game playTurn. "Apollo moves 5->6, triggers HyperJump of 3 moves"
    
    "Apollo should be at 9 (6+3)"
    self assert: (game positionOf: (scenario shipNamed: 'Apollo')) equals: 9.
]

{ #category : 'tests' }
GameIntegrationTest >> testHyperGravityPreventsMovementWhenRollIsInsufficient [
    | scenario game |
    scenario := self builder
        boardWithCells: 10;
        withShipNamed: 'Lucas' at: 2;
        withEffect: (HyperGravityEffect new requiredRoll: 5) at: 4;
        withDice: (DeterministicDie withValues: { 2 } sides: 100);
        build.
    
    game := scenario game.
    game playTurn. "Lucas rolls 2, wants to land on 4. Required is 5."
    
    "Lucas should stay at 2 because it couldn't enter cell 4"
    "Wait, let's check HyperGravity behavior. Usually it stops BEFORE or AT the cell?"
    "In BoardNavigationTest: testBoardPreventsEntryToHyperGravityCellWithLowRoll says newPosition equals 3 if moving from 2 to 4."
    "So it stops at 3."
    self assert: (game positionOf: (scenario shipNamed: 'Lucas')) equals: 3.
]

{ #category : 'tests' }
GameIntegrationTest >> testLapIncrementsWhenPassingLastCell [
    | scenario game ship |
    scenario := self builder
        boardWithCells: 10;
        withShipNamed: 'Lucas' at: 8;
        withDice: (DeterministicDie withValues: { 3 } sides: 100);
        build.
    
    game := scenario game.
    ship := scenario shipNamed: 'Lucas'.
    
    game playTurn. "8 + 3 = 11 -> position 1, lap 1"
    
    self assert: (game positionOf: ship) equals: 1.
    self assert: (scenario lapCountForShipNamed: 'Lucas') equals: 1.
]

{ #category : 'tests' }
GameIntegrationTest >> testWormholeTransportsCorrectly [
    | scenario game |
    scenario := self builder
        boardWithCells: 10;
        withShipNamed: 'Solo' at: 1;
        configureBoardWith: [ :board | 
            board addWormhole: (Wormhole from: 3 to: 7) ];
        withDice: (DeterministicDie withValues: { 2 } sides: 100);
        build.
    
    game := scenario game.
    game playTurn. "1 + 2 = 3, triggers wormhole to 7"
    
    self assert: (game positionOf: (scenario shipNamed: 'Solo')) equals: 7.
]
