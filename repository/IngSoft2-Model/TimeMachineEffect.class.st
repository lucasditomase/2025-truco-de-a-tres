Class {
	#name : 'TimeMachineEffect',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'application' }
TimeMachineEffect >> applyTo: aShip inGame: aGame [
	| targets restoredFuel |
	targets := self targetsFor: aShip.

	"Single-pass: validate each target and collect the fuel values to restore,
	then apply the restoration. This avoids iterating targets twice and
	keeps validation declarative via `canBeAppliedTo:inGame:`."
	restoredFuel := Dictionary new.
	targets do: [ :ship |
		(self canBeAppliedTo: ship inGame: aGame)
			ifFalse: [ self error: 'Not enough turns to use Time Machine' ].
		restoredFuel at: ship put: (aGame antepenultimateFuelFor: ship).
	].

	restoredFuel keysAndValuesDo: [ :ship :fuel |
		ship restoreFuelTo: fuel
	]
]

{ #category : 'private' }
TimeMachineEffect >> restoredFuelFor: aShip inGame: aGame [
	^ aGame antepenultimateFuelFor: aShip
]

{ #category : 'private' }
TimeMachineEffect >> restoreFuelFor: targets inGame: aGame [
	"Deprecated: use `applyTo:inGame:` for single-pass validate+apply behavior.
	This helper retained for backward compatibility; delegates to new API."
	targets do: [ :ship |
		ship restoreFuelTo: (aGame antepenultimateFuelFor: ship)
	]
]

{ #category : 'private' }
TimeMachineEffect >> targetsFor: aShip [
	| targets |
	targets := OrderedCollection with: aShip.
	targets addAll: aShip allies.
	^ targets
]

{ #category : 'validation' }
TimeMachineEffect >> validate: targets inGame: aGame [
	targets do: [ :ship | 
		(self canBeAppliedTo: ship inGame: aGame)
			ifFalse: [ self error: 'Not enough turns to use Time Machine' ] ]
]

{ #category : 'validation' }
TimeMachineEffect >> canBeAppliedTo: aShip inGame: aGame [
	^ aGame canUseTimeMachine: aShip
]
