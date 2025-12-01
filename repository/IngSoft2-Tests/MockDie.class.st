Class {
    #name : 'MockDie',
    #superclass : 'Object',
    #instVars : [
        'value',
        'sides'
    ],
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'instance creation' }
MockDie class >> value: aValue sides: aSideCount [
    ^ self new initializeWithValue: aValue sides: aSideCount
]

{ #category : 'initialization' }
MockDie >> initializeWithValue: aValue sides: aSideCount [
    value := aValue.
    sides := aSideCount.
    ^ self
]

{ #category : 'rolling' }
MockDie >> roll [
    ^ value
]

{ #category : 'accessing' }
MockDie >> sides [
    ^ sides
]
