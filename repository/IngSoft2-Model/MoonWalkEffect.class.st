Class {
    #name : 'MoonWalkEffect',
    #superclass : 'EffectDecorator',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
MoonWalkEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
        ^ self.
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships [
    self applyTo: aSpaceship inContextOf: allSpaceships inBoard: NullBoard new.
]

{ #category : 'operations' }
MoonWalkEffect >> applyTo: aSpaceship inContextOf: allSpaceships inBoard: aBoard [
        allSpaceships do: [:ship | ship = aSpaceship ifFalse: [
            aBoard moveShip: ship backward: 2
        ]].
]
