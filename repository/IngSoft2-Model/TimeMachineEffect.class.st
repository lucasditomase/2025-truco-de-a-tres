Class {
	#name : 'TimeMachineEffect',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'application' }
TimeMachineEffect >> applyTo: aShip inGame: aGame [
    | targets |
    targets := self targetsFor: aShip.
    self validate: targets inGame: aGame.
    self restoreFuelFor: targets inGame: aGame
]

{ #category : 'private' }
TimeMachineEffect >> restoredFuelFor: aShip inGame: aGame [
	^ aGame antepenultimateFuelFor: aShip
]

{ #category : 'private' }
TimeMachineEffect >> restoreFuelFor: targets inGame: aGame [
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
