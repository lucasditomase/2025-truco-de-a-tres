Class {
	#name : 'NullRequiredRollTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
NullRequiredRollTest >> testValue [
    self assert: NullRequiredRoll new value equals: 4.
]

{ #category : 'tests' }
NullRequiredRollTest >> testIsNullRequired [
    self assert: NullRequiredRoll new isNullRequired.
]
