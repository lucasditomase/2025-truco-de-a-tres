Class {
    #name : 'LapTracker',
    #superclass : 'Object',
    #instVars : [
        'board',
        'statusLookup'
    ],
    #category : 'IngSoft2-Model',
    #package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
LapTracker class >> forBoard: aBoard statuses: aDictionary [
    ^ self new initializeForBoard: aBoard statuses: aDictionary
]

{ #category : 'initialization' }
LapTracker >> initializeForBoard: aBoard statuses: aDictionary [
    board := aBoard.
    statusLookup := aDictionary.
    ^ self
]

{ #category : 'actions' }
LapTracker >> registerLapFor: aShip from: start after: delta [
    | status |
    delta = 0 ifTrue: [ ^ self ].
    status := statusLookup at: aShip.

    delta > 0
        ifTrue: [ self registerForwardLapFor: status from: start after: delta ]
        ifFalse: [ self registerBackwardLapFor: status from: start after: delta ].
]

{ #category : 'private' }
LapTracker >> registerForwardLapFor: status from: start after: delta [
    start + delta < board cellCount ifTrue: [ ^ self ].
    status addLap
        | length normalizedStart total laps |
        length := (board cellCount max: 1).
        normalizedStart := start \\ length.
        total := normalizedStart + delta.
        laps := total // length.
        laps <= 0 ifTrue: [ ^ self ].
        laps timesRepeat: [ status addLap ].
    ]

{ #category : 'private' }
LapTracker >> registerBackwardLapFor: status from: start after: delta [
    start + delta >= 0 ifTrue: [ ^ self ].
    status removeLap
        | length normalizedStart steps laps |
        length := (board cellCount max: 1).
        normalizedStart := start \\ length.
        steps := delta abs.
        laps := ((steps - normalizedStart) + (length - 1)) // length.
        laps <= 0 ifTrue: [ ^ self ].
        laps timesRepeat: [ status removeLap ].
    ]
