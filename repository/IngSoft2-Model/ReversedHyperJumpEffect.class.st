Class {
    #name : 'ReversedHyperJumpEffect',
    #superclass : 'HyperJumpEffect',
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'operations' }
ReversedHyperJumpEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    | parsecs steps |
    parsecs := self nextJumpValue.
    steps := (parsecs / aBoard totalLengthInParsecs * aBoard cellCount) rounded.
    aBoard moveShip: aSpaceship backward: steps.
]
