Extension {
    #name : 'Object'
}

{ #category : '*IngSoft2-Model-validation' }
Object >> validateAsBoard [
    ^ self validateAs: #Board
]

{ #category : '*IngSoft2-Model-validation' }
Object >> validateAsSpaceship [
    ^ self validateAs: #Spaceship
]

{ #category : '*IngSoft2-Model-validation' }
Object >> validateAsDiceCup [
    ^ self validateAs: #DiceCup
]

{ #category : '*IngSoft2-Model-validation' }
Object >> validateAs: aSymbol [
    ^ self
]

{ #category : '*IngSoft2-Model-testing' }
Object >> isNullShip [
    ^ false
]
