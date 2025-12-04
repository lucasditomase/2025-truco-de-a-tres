Class {
	#name : 'GameRulesTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests - constants' }
GameRulesTest >> testDefaultMaxDiceRollReturns6 [
	self assert: GameRules defaultMaxDiceRoll equals: 6
]
