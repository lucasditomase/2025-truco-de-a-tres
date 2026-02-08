Class {
	#name : 'GameSimulationTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameSimulationTest >> testFullGameSimulation [
	| game ships winner turnCount itemToCancel builder |
	
	"1. Setup Simulation"
	ships := { 'Ship1'. 'Ship2'. 'Ship3' }.
	builder := GameTestBuilder new
		withShipNames: ships;
		boardWithCells: 30;
		laps: 2;
		withDeckCyclingThrough: Card allCardTypes;
		withDice: (Die withSides: 6);
		"Place all effects on the board"
		withEffect: AtomicBombEffect new at: 5;
		withEffect: (MoonWalkEffect withSteps: 2) at: 8;
		withEffect: (HyperGravityEffect new requiredRoll: 4) at: 12;
		withEffect: BlackHoleEffect new at: 15;
		withEffect: (HyperJumpEffect withValues: #(5 2)) at: 20;
		withEffect: (Wormhole from: 2 to: 10) at: 25.
	game := builder build game.

	turnCount := 0.
	
	"2. Run Simulation Loop"
	[ game isOver ] whileFalse: [
		| currentShip cardToPlay cardsInHand |
		turnCount := turnCount + 1.
		self assert: turnCount < 1000 description: 'Game took too long'.
		
		currentShip := game currentShip.
        
        self playAIStrategyFor: game.
        
        "5. Play Turn (Roll & Move)"
        game playTurn.
    ].

	"6. Verification"
	self assert: game isOver.
	winner := game winner.
	self assert: (ships includes: winner name).
	self assert: winner lap >= 2.
]

{ #category : 'tests' }
GameSimulationTest >> testFullGameScenarioDeterministic [
    | game ship1 ship2 winner builder |
    
    "1. Setup with Deterministic Dice to control flow"
    builder := GameTestBuilder new
        withShipNames: #('Winner' 'Loser');
        boardWithCells: 10;
        laps: 1;
        withDice: (DeterministicDie withValues: #(6 1 0 2 0 3 0 4 0 5 0 6));
        withDeckCyclingThrough: { AccelerationCard. OverloadCard };
        withEffect: AtomicBombEffect new at: 5.
    game := builder build game.
        
    ship1 := game spaceShips first.
    ship2 := game spaceShips second.
    
    "2. Ship1 Turn: Rolls 1 -> Pos 1"
    game playTurn. 
    self assert: ship1 position equals: 1.
    
    "3. Ship2 Turn: Rolls 2 -> Pos 2"
    game playTurn.
    self assert: ship2 position equals: 2.
    
    "4. Force Penalization on Ship1"
    "Drain fuel to force penalty on next move"
    ship1 fuel: 0.
    game playTurn. "Ship1 attempts to move but has 0 fuel -> Penalty"
    self assert: (game isPenalized: ship1) description: 'Ship1 should be penalized due to lack of fuel'.
    self assert: ship1 position equals: 0 description: 'Ship1 should be reset to 0'.
    
    "5. Card Play: Ship2 uses Acceleration"
    "Ensure Ship2 has a card (dealt at start or turn?)"
    ship2 addCard: AccelerationCard new.
    ship2 playCard: ship2 cards last inGame: game.
    self assert: (game activeCards anySatisfy: [ :c | c isKindOf: AccelerationCard ]).
    
    "6. Finish Game"
    "Teleport Ship2 to winning condition to verify end game"
    ship2 moveForward: 20. "Cross lap line"
    
    self assert: game isOver description: 'Game should be over after Ship2 crosses finish line'.
    winner := game winner.
    self assert: winner name equals: 'Winner' description: 'Ship2 (Winner) should win'.
    self assert: (game isPenalized: ship1) description: 'Loser should still be penalized or in bad state'.
]

{ #category : 'helpers' }
GameSimulationTest >> playAIStrategyFor: game [
    | currentShip cardToPlay cardsInHand itemToCancel |
    currentShip := game currentShip.
    cardsInHand := currentShip cards.
    
    (cardsInHand isNotEmpty and: [ (1 to: 100) atRandom <= 50 ]) ifTrue: [
        cardToPlay := cardsInHand atRandom.
        
        (cardToPlay isKindOf: AllyCard) ifTrue: [
            cardToPlay allyShip: ((game spaceShips copyWithout: currentShip) atRandom).
        ].
        (cardToPlay isKindOf: OverloadCard) ifTrue: [
            cardToPlay targetShip: ((game spaceShips copyWithout: currentShip) atRandom).
        ].
        (cardToPlay isKindOf: RepeatCard) ifTrue: [
            cardToPlay targetShip: (game spaceShips atRandom).
        ].
        (cardToPlay isKindOf: CancellationCard) ifTrue: [
            game activeCards ifNotEmpty: [ 
                itemToCancel := game activeCards atRandom.
                cardToPlay cardToCancel: itemToCancel.
            ] ifEmpty: [
                cardToPlay := nil.
            ].
        ].
        
        cardToPlay ifNotNil: [
            currentShip playCard: cardToPlay inGame: game.
        ].
    ].
]
