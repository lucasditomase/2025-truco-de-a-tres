Class {
	#name : 'CardRegistryTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CardRegistryTest >> testAllCardTypesReturnsCollectionOfCardClasses [
	| cardTypes |
	cardTypes := CardRegistry allCardTypes.
	
	self assert: cardTypes isCollection.
	self assert: cardTypes notEmpty.
	self assert: (cardTypes includes: OverloadCard).
	self assert: (cardTypes includes: AllyCard).
	self assert: (cardTypes includes: AccelerationCard).
	self assert: (cardTypes includes: CancellationCard).
	self assert: (cardTypes includes: RedoCard).
	self assert: (cardTypes includes: RepeatCard).
	self assert: (cardTypes includes: ReversalCard).
	self assert: (cardTypes includes: TimeMachineCard).
]

{ #category : 'tests' }
CardRegistryTest >> testPermanentCardTypesReturnsOnlyPermanentCards [
	| permanentCardTypes |
	permanentCardTypes := CardRegistry permanentCardTypes.
	
	self assert: permanentCardTypes isCollection.
	permanentCardTypes do: [ :cardClass |
		self assert: (cardClass includesBehavior: PermanentCard).
		self deny: cardClass = PermanentCard ].
]

{ #category : 'tests' }
CardRegistryTest >> testInstantCardTypesReturnsOnlyInstantCards [
	| instantCardTypes |
	instantCardTypes := CardRegistry instantCardTypes.
	
	self assert: instantCardTypes isCollection.
	instantCardTypes do: [ :cardClass |
		self assert: (cardClass includesBehavior: InstantCard).
		self deny: cardClass = InstantCard ].
]

{ #category : 'tests' }
CardRegistryTest >> testCardCountReturnsCorrectNumber [
	| count allCards |
	allCards := CardRegistry allCardTypes.
	count := CardRegistry cardCount.
	
	self assert: count equals: allCards size.
	self assert: count > 0.
]

{ #category : 'tests' }
CardRegistryTest >> testHasCardTypeReturnsTrueForExistingCard [
	self assert: (CardRegistry hasCardType: OverloadCard).
	self assert: (CardRegistry hasCardType: AllyCard).
	self assert: (CardRegistry hasCardType: AccelerationCard).
]

{ #category : 'tests' }
CardRegistryTest >> testHasCardTypeReturnsFalseForNonExistingCard [
	self deny: (CardRegistry hasCardType: NullCard).
]
