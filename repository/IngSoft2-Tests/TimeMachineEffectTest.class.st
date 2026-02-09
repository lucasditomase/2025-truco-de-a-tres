Class {
	#name : 'TimeMachineEffectTest',
	#superclass : 'GameIntegrationTest',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
TimeMachineEffectTest >> testApplyToRestoresFuel [
    | scenario game ship effect initialFuel |
    scenario := self builder
        withShipNames: #('Alpha' 'Beta');
        build.
    game := scenario game.
    ship := scenario shipNamed: 'Alpha'.
    effect := TimeMachineEffect new.
    
    initialFuel := (game statusFor: ship) fuel.
    
    "Advance turns to build history"
    4 timesRepeat: [ game playTurn ].
    
    "Consume some fuel manually or via play to ensure difference"
    ship fuel: 0.
    
    effect applyTo: ship inGame: game.
    
    self assert: (game statusFor: ship) fuel equals: initialFuel.
]
