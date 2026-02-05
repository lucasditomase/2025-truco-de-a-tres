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
