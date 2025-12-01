Class {
    #name : 'BlockEffect',
    #superclass : 'EffectDecorator',
    #instVars : [
        'action'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
BlockEffect class >> on: aBlock [
    ^ self new initializeWith: aBlock
]

{ #category : 'initialization' }
BlockEffect >> initializeWith: aBlock [
    super initialize.
    action := aBlock.
    ^ self
]

{ #category : 'operations' }
BlockEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    action value: aSpaceship value: aBoard.
]
