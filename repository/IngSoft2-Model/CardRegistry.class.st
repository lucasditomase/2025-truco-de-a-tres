Class {
	#name : 'CardRegistry',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
CardRegistry class >> allCardTypes [
	
	
	
	^ OrderedCollection new
		add: OverloadCard;
		add: AllyCard;
		add: AccelerationCard;
		add: CancellationCard;
		add: RedoCard;
		add: RepeatCard;
		add: ReversalCard;
		add: TimeMachineCard;
		yourself
]

{ #category : 'accessing' }
CardRegistry class >> permanentCardTypes [
	
	
	^ self allCardTypes select: [ :cardClass | 
		(cardClass includesBehavior: PermanentCard) and: [ cardClass ~= PermanentCard ] ]
]

{ #category : 'accessing' }
CardRegistry class >> instantCardTypes [
	
	
	^ self allCardTypes select: [ :cardClass | 
		(cardClass includesBehavior: InstantCard) and: [ cardClass ~= InstantCard ] ]
]

{ #category : 'querying' }
CardRegistry class >> cardCount [
	
	^ self allCardTypes size
]

{ #category : 'querying' }
CardRegistry class >> hasCardType: aCardClass [
	
	^ self allCardTypes includes: aCardClass
]
