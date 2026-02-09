Class {
	#name : 'TimeMachineEffectTest',
	#superclass : 'GameIntegrationTest',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
TimeMachineEffectTest >> testApplyToRestoresFuel [
    | scenario game ship effect initialFuel currentFuel |
    scenario := self builder
        withShipNames: #('Alpha');
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    effect := TimeMachineEffect new.
    
    initialFuel := (game statusFor: ship) fuel.
    
    
    4 timesRepeat: [ game playTurn ].
    
    
    ship fuel: 0.
    currentFuel := (game statusFor: ship) fuel.
    self deny: currentFuel equals: initialFuel.
    
    effect applyTo: ship inGame: game.
    
    self assert: (game statusFor: ship) fuel equals: initialFuel.
]

{ #category : 'tests' }
TimeMachineEffectTest >> testTimeMachineRaisesErrorWhenAppliedTooEarly [
    | scenario game ship effect |
    scenario := self builder
        withShipNames: #('Alpha');
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    effect := TimeMachineEffect new.
    
    
    self
        should: [ effect applyTo: ship inGame: game ]
        raise: Error
        withMessageText: 'Not enough turns to use Time Machine'
]

{ #category : 'tests' }
TimeMachineEffectTest >> testRestoredFuelAccessHelper [
    | scenario game ship effect restoredFuel |
    scenario := self builder
        withShipNames: #('Alpha');
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    effect := TimeMachineEffect new.
    
    4 timesRepeat: [ game playTurn ].
    
    
    restoredFuel := effect restoredFuelFor: ship inGame: game.
    self assert: restoredFuel >= 0.
]
