Class {
    #name : 'TimeMachineCardTest',
    #superclass : 'GameIntegrationTest',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
TimeMachineCardTest >> testTimeMachineRestoresFuelToStartOfPenultimateTurn [
    | scenario game ship1 card deterministicDie initialFuel |
    
    deterministicDie := DeterministicDie withValues: #(10) sides: 10.
    scenario := self builder
        withShipNames: #('Alpha');
        diceCup: [ DiceCup with: { deterministicDie } ];
        laps: 3;
        boardWithCells: 100;
        build.
    game := scenario game.
    ship1 := scenario shipNamed: 'Alpha'.
    
    
    game playTurn.
    game playTurn.
    
    card := TimeMachineCard new.
    ship1 playCard: card inGame: game.
    
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
    
    ship1 addCard: card.
    
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
    
    
    ally := AllyCard withAlly: ship2.
    ship1 addCard: ally.
    ship1 playCard: ally inGame: game.
    
    4 timesRepeat: [ game playTurn ].
    
    4 timesRepeat: [ game playTurn ].
    
    card := TimeMachineCard new.
    ship1 addCard: card.
    ship1 playCard: card inGame: game.
    
    ship1 playCard: card inGame: game.
    
    self assert: ship1 fuel equals: ship1Initial.
    self assert: ship2 fuel equals: ship2Initial.
]
