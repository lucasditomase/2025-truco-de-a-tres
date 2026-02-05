Class {
    #name : 'TurnDataTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'support' }
TurnDataTest >> shipNamed: aName withFuel: fuelAmount [
    | ship |
    ship := Spaceship withName: aName.
    ship maxFuel: fuelAmount.
    ship fuel: fuelAmount.
    ^ ship
]

{ #category : 'tests' }
TurnDataTest >> testInitializeFuelHistoryStoresInitialFuelValues [
    | data shipA shipB |
    data := TurnData new.
    shipA := self shipNamed: 'Alpha' withFuel: 5.
    shipB := self shipNamed: 'Beta' withFuel: 8.

    data initializeFuelHistoryForShips: { shipA. shipB }.

    self assert: (data fuelHistoryFor: shipA) equals: (OrderedCollection with: 5).
    self assert: (data fuelHistoryFor: shipB) equals: (OrderedCollection with: 8)
]

{ #category : 'tests' }
TurnDataTest >> testRecordFuelForKeepsOnlyLastThreeEntries [
    | data ship |
    data := TurnData new.
    ship := self shipNamed: 'Recorder' withFuel: 10.

    #(10 9 8 7) do: [ :value |
        ship fuel: value.
        data recordFuelFor: ship ].

    self assert: (data fuelHistoryFor: ship)
        equals: #(9 8 7) asOrderedCollection
]

{ #category : 'tests' }
TurnDataTest >> testFuelHistoryForReturnsEmptyCollectionWhenUnknown [
    | data ship history |
    data := TurnData new.
    ship := self shipNamed: 'Stranger' withFuel: 5.

    history := data fuelHistoryFor: ship.

    self assert: history isEmpty.
    self assert: history class equals: OrderedCollection.
]

{ #category : 'tests' }
TurnDataTest >> testLastCardPlayedTracksEffectiveCardWhenRecording [
    | data card |
    data := TurnData new.
    card := AdvanceCard new.

    data lastCardPlayed: card.

    self assert: data lastCardPlayed equals: card.
    self assert: data lastEffectWasCard.
    self assert: data lastEffectiveCard equals: card
]

{ #category : 'tests' }
TurnDataTest >> testLastCardPlayedIgnoresCardsThatDoNotRecord [
    | data card |
    data := TurnData new.
    card := RepeatCard new.

    data lastCardPlayed: card.

    self assert: data lastCardPlayed equals: card.
    self deny: data lastEffectWasCard.
    self assert: data lastEffectiveCard class equals: NullCard
]

{ #category : 'tests' }
TurnDataTest >> testFuelHistorySetterReplacesDictionary [
    | data ship history |
    data := TurnData new.
    ship := self shipNamed: 'Stored' withFuel: 9.
    history := Dictionary new.
    history at: ship put: (OrderedCollection with: 3 with: 4).

    data fuelHistory: history.

    self assert: (data fuelHistoryFor: ship) equals: (OrderedCollection with: 3 with: 4).
]

{ #category : 'tests' }
TurnDataTest >> testLastEffectiveCardSetterStoresCard [
    | data card |
    data := TurnData new.
    card := ShieldCard new.

    data lastEffectiveCard: card.

    self assert: data lastEffectiveCard equals: card.
]
