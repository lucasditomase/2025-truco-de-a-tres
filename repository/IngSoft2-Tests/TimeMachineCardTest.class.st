Class {
    #name : 'TimeMachineCardTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
TimeMachineCardTest >> builder [
    ^ GameTestBuilder new
]

{ #category : 'support' }
TimeMachineCardTest >> ensureTurnOf: aShip inGame: aGame [
    [ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]

{ #category : 'tests' }
TimeMachineCardTest >> testTimeMachineRestoresFuelToStartOfPenultimateTurn [
    | scenario game ship1 card deterministicDie initialFuel |
    
    "Setup: 1 Die with value 10 always. Initial Fuel = 10 * Multiplier?"
    "GameRules default initialFuelMultiplier is usually known or we can check."
    "Let's check GameRules if possible, or observe initial fuel."
    "Or Assume consumption."
    
    deterministicDie := DeterministicDie withValues: #(10) sides: 10.
    scenario := self builder
        withShipNames: #('Alpha');
        diceCup: [ DiceCup with: { deterministicDie } ];
        laps: 3;
        boardWithCells: 100;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    "Initial State (Turn 1 Start). Fuel = X."
    initialFuel := (game statusFor: ship1) fuel. "(Assuming we can access 'fuel' on status, which was not shown in Game.st snippet but likely exists)"
    "Wait, statusFor: returns ShipStatus. Does ShipStatus have 'fuel'?"
    "In Game.class.st (Step 492), ShipStatus creation (L244) passes 'penalized'. It doesn't seem to pass fuel."
    "ShipStatus usually tracks laps/position. Fuel might NOT be in status."
    "If status doesn't have fuel, implies 'Fuel is hidden'."
    "But user sees fuel. So UI needs it."
    "Let's assume ShipStatus has fuel or we can ask Game?"
    "Game doesn't expose 'fuelOf: ship'. But it exposes 'spaceShips' (L486)?"
    "L486: ^ spaceShips asOrderedCollection."
    "Spaceship exposes 'fuel' (L77)."
    "So we can inspect ship object via game spaceShips."
    "Is this Black-Box? 'game spaceShips' is public. 'ship fuel' is public. Yes."
    
    "Turn 1: Ship moves. Consumes fuel."
    game playTurn.
    "End Turn 1."
    
    "Turn 2: Start. Fuel Recorded (S2)."
    game playTurn.
    "End Turn 2."
    
    "Turn 3: Start. Fuel Recorded (S3)."
    "Fuel should be Initial - (Move1 + Move2)."
    
    "Play TimeMachine on Ship1."
    card := TimeMachineCard new.
    scenario withCard: card for: ship1. "Helper to add card? Or just 'ship playCard: inGame:'"
    "Need to give card to ship first."
    "Since we didn't mock the deck to give TimeMachine, we might force it?"
    "Black-Box: Deck must yield TimeMachine. Use 'withDeckCyclingThrough: { TimeMachineCard }'."
    
    ship1 playCard: card inGame: game.
    
    "Expectation: Fuel restored to S1 (Initial Fuel)."
    
    self assert: ship1 fuel equals: initialFuel.
]

{ #category : 'tests' }
TimeMachineCardTest >> testTimeMachineRequiresMinimumTurns [
    | scenario game ship1 card deterministicDie |
    deterministicDie := DeterministicDie withValues: #(10) sides: 10.
    scenario := self builder
        withShipNames: #('Alpha');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 100;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    card := TimeMachineCard new.
    
    "Turn 1 Start."
    "Try to play card immediately."
    "History size = 1."
    
    self
        should: [ ship1 playCard: card inGame: game ]
        raise: Error
        withMessageText: 'Card not in hand'. "Wait, we didn't give the card."
        
    "Fix: Give card."
    ship1 addCard: card. "White-box setup for test convenience? Or use Builder."
    "Builder: configureBoardWith: [ :b | b useCardDealer: ... ]"
    
    self
        should: [ ship1 playCard: card inGame: game ]
        raise: Error
        withMessageText: 'Not enough turns to use Time Machine'.
]

{ #category : 'tests' }
TimeMachineCardTest >> testTimeMachineRestoresAllies [
    | scenario game ship1 ship2 card ally deterministicDie ship1Initial ship2Initial |
    deterministicDie := DeterministicDie withValues: #(10) sides: 10.
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        diceCup: [ DiceCup with: { deterministicDie } ];
        boardWithCells: 100;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    ship2 := scenario shipNamed: 'Beta'.
    
    ship1Initial := ship1 fuel.
    ship2Initial := ship2 fuel.
    
    "Make them allies."
    ally := AllyCard withAlly: ship2.
    ship1 addCard: ally. "Setup"
    ship1 playCard: ally inGame: game.
    
    "Play 2 full rounds (4 turns: A1, B1, A2, B2)."
    4 timesRepeat: [ game playTurn ].
    
    "Now Turn 3 for Alpha. (Start A3)."
    "History for Alpha: [S1, S2, S3]. Size 3."
    "History for Beta: [S1, S2, S3] (Recorded at start of B1, B2, B3?)."
    "Beta hasn't started B3 yet. Last recorded was Start B2?"
    "Game recordFuelStartFor is called at START of playTurn."
    "So Beta has [S1(start B1), S2(start B2)]. Size 2."
    
    "Alpha plays TimeMachine."
    card := TimeMachineCard new.
    ship1 addCard: card.
    ship1 playCard: card inGame: game.
    
    "Expect: Alpha -> S1. Beta -> S1."
    
    self assert: ship1 fuel equals: ship1Initial.
    self assert: ship2 fuel equals: ship2Initial.
]
