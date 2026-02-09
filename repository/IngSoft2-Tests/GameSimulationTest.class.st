Class {
	#name : 'GameSimulationTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameSimulationTest >> testFullGameSimulation [
	| game ships winner turnCount itemToCancel builder |
	
	
	ships := { 'Ship1'. 'Ship2'. 'Ship3' }.
	builder := GameTestBuilder new
		withShipNames: ships;
		boardFactory: [ Board of: 30 andWormholeAt: { Wormhole from: 2 to: 10 } ];
		laps: 2;
		withDeckCyclingThrough: Card allCardTypes;
		withDice: (Die withSides: 6);
		
		withEffect: AtomicBombEffect new at: 5;
		withEffect: (MoonWalkEffect withSteps: 2) at: 8;
		withEffect: (HyperGravityEffect new requiredRoll: 4) at: 12;
		withEffect: BlackHoleEffect new at: 15;
		withEffect: (HyperJumpEffect withValues: #(5 2)) at: 20.
	game := builder build game.

	turnCount := 0.
	
	
	[ game isOver ] whileFalse: [
		| currentShip cardToPlay cardsInHand |
		turnCount := turnCount + 1.
		self assert: turnCount < 1000 description: 'Game took too long'.
		
		currentShip := game currentShip.
        
        self playAIStrategyFor: game.
        
        
        game playTurn.
    ].

	
	self assert: game isOver.
	winner := game winner.
	self assert: (ships includes: winner name).
	self assert: (game lapTrackerFor: winner) lapCount >= 2.
]

{ #category : 'tests' }
GameSimulationTest >> testFullGameScenarioDeterministic [
    | game ship1 ship2 winner builder |
    
    
    builder := GameTestBuilder new
        withShipNames: #('Loser' 'Winner');
        boardWithCells: 10;
        laps: 1;
        withDice: (DeterministicDie withValues: #(7 1 7 2 7 3 7 20));
        withDeckCyclingThrough: { AccelerationCard. OverloadCard };
        withEffect: AtomicBombEffect new at: 5.
    game := builder build game.
        
    ship1 := game spaceShips first.
    ship2 := game spaceShips second.
    
    
    game playTurn. 
    self assert: ship1 position equals: 1.
    
    
    game playTurn.
    self assert: ship2 position equals: 2.
    
    
    
    ship1 fuel: 0.
    game playTurn. 
    self assert: (game isPenalized: ship1) description: 'Ship1 should be penalized due to lack of fuel'.
    self assert: ship1 position equals: 0.
    
    
    
    ship2 addCard: AccelerationCard new.
    ship2 playCard: ship2 cards last inGame: game.
    self assert: (game activeCards anySatisfy: [ :c | c isKindOf: AccelerationCard ]).
    
    
    
    
    
    game playTurn. 
    
    self assert: game isOver description: 'Game should be over after Ship2 crosses finish line'.
    winner := game winner.
    self assert: winner name equals: 'Winner'.
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
        (cardToPlay isKindOf: TimeMachineCard) ifTrue: [
             (game canUseTimeMachine: currentShip) ifFalse: [ cardToPlay := nil ].
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
            [ currentShip playCard: cardToPlay inGame: game ]
                on: Error
                do: [ :e | "Ignore invalid plays during random simulation" ]
        ].
    ].
]
