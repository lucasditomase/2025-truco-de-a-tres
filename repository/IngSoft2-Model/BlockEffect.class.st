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
    ^ self new initializeWith: (self ensureActionBlockFrom: aBlock)
]

{ #category : 'validation' }
BlockEffect class >> ensureActionBlockFrom: aBlock [
    ((aBlock isKindOf: BlockClosure) and: [ aBlock numArgs = 2 ]) ifFalse: [
        self error: 'Block effect action must be a block that takes two arguments'
    ].
    ^ aBlock
]

{ #category : 'initialization' }
BlockEffect >> initializeWith: aBlock [
    super initialize.
    action := self class ensureActionBlockFrom: aBlock.
    ^ self
]

{ #category : 'operations' }
BlockEffect >> applyEffectTo: aSpaceship inBoard: aBoard [
    action value: aSpaceship value: aBoard.
]
