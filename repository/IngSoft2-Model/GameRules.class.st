Class {
    #name : 'GameRules',
    #superclass : 'Object',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'constants' }
GameRules class >> maxRollRewardProbability [
    ^ 80
]

{ #category : 'constants' }
GameRules class >> initialFuelMultiplier [
    ^ 2
]

{ #category : 'constants' }
GameRules class >> fuelExhaustionPenaltyTurns [
    ^ 2
]

{ #category : 'constants - effect distribution' }
GameRules class >> noEffectWeight [
    
    
    ^ 38
]

{ #category : 'constants - effect distribution' }
GameRules class >> cardEffectWeight [
    
    
    ^ 10
]

{ #category : 'constants - effect distribution' }
GameRules class >> blackHoleEffectWeight [
    
    
    ^ 20
]

{ #category : 'constants - effect distribution' }
GameRules class >> hyperGravityEffectWeight [
    
    
    ^ 20
]

{ #category : 'constants - effect distribution' }
GameRules class >> moonWalkEffectWeight [
    
    
    ^ 10
]

{ #category : 'constants - effect distribution' }
GameRules class >> hyperJumpEffectWeight [
    
    
    ^ 8
]

{ #category : 'constants - effect distribution' }
GameRules class >> atomicBombEffectWeight [
    
    
    ^ 2
]

{ #category : 'constants' }
GameRules class >> defaultMaxDiceRoll [
    
    
    ^ 6
]
