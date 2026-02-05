Class {
	#name : 'GameIntegrationTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'support' }
GameIntegrationTest >> builder [
	"Provide GameTestBuilder for fluent game scenario setup.
	 This method is used across all integration tests to create game configurations."
	^ GameTestBuilder new
]

{ #category : 'support' }
GameIntegrationTest >> ensureTurnOf: aShip inGame: aGame [
	"Advance game turns until the specified ship becomes current player.
	 Useful for setting up test scenarios where a specific ship needs to play."
	[ aGame currentShip = aShip ] whileFalse: [ aGame advanceTurn ]
]
