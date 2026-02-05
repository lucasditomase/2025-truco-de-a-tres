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

{ #category : 'asserting' }
GameIntegrationTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [
    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: error messageText equals: errorMessage ]
]
