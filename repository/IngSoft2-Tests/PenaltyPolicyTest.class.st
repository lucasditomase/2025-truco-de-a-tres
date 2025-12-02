Class {
    #name : 'PenaltyPolicyTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
PenaltyPolicyTest >> sampleStatusesDictionary [
    | ship status |
    ship := Spaceship withName: 'Voyager'.
    status := ShipStatus for: ship position: 0 laps: 0 penalized: false.
    ^ Dictionary new
        at: ship put: status;
        yourself
]

{ #category : 'tests' }
PenaltyPolicyTest >> testWithStatusesReturnsPolicy [
    | policy |
    policy := PenaltyPolicy
        withStatuses: self sampleStatusesDictionary
        restoreFuelWith: [ :ship | ship restoreFuel ].
    self assert: policy class equals: PenaltyPolicy.
]

{ #category : 'tests' }
PenaltyPolicyTest >> testWithStatusesRequiresDictionary [
    self
        should: [ PenaltyPolicy withStatuses: #() restoreFuelWith: [ :ship | ship restoreFuel ] ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Ship statuses must be stored in a Dictionary' ].
]

{ #category : 'tests' }
PenaltyPolicyTest >> testWithStatusesRequiresShipStatusValues [
    | invalid |
    invalid := Dictionary new
        at: 'Ship' put: 'Not a status';
        yourself.
    self
        should: [ PenaltyPolicy withStatuses: invalid restoreFuelWith: [ :ship | ship restoreFuel ] ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Ship statuses must contain ShipStatus values' ].
]

{ #category : 'tests' }
PenaltyPolicyTest >> testWithStatusesRequiresFuelRestorerBlock [
    self
        should: [ PenaltyPolicy withStatuses: self sampleStatusesDictionary restoreFuelWith: 'not a block' ]
        raise: Error
        withExceptionDo: [ :error |
            self assert: error messageText equals: 'Fuel restorer must be a block' ].
]
