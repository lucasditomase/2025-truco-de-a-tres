Class {
    #name : 'SpaceshipTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'tests - instance' }
SpaceshipTest >> testActiveCardsStartsEmpty [
    | ship |

    ship := Spaceship withName: 'Empty'.

    self assert: ship activeCards isEmpty.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testAddActiveCardAddsCard [
    | ship card |

    ship := Spaceship withName: 'Adder'.
    card := AccelerationCard new.
    ship addActiveCard: card.

    self assert: (ship activeCards includes: card).
]

{ #category : 'tests - instance' }
SpaceshipTest >> testAddCardAddsToHand [
    | ship card |

    ship := Spaceship withName: 'Collector'.
    card := AdvanceCard new.
    ship addCard: card.

    self assert: (ship cards includes: card).
]

{ #category : 'tests - instance' }
SpaceshipTest >> testCardsReturnsCurrentCards [
    | ship card |

    ship := Spaceship withName: 'Holder'.
    card := AdvanceCard new.
    ship addCard: card.

    self assert: ship cards size equals: 1.
    self assert: (ship cards first) equals: card.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testDecreaseFuelByDoesNotGoBelowZero [
    | ship |

    ship := Spaceship withName: 'Fueler'.
    ship fuel: 5.
    ship decreaseFuelBy: 3.
    self assert: ship fuel equals: 2.
    ship decreaseFuelBy: 10.
    self assert: ship fuel equals: 0.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testHasNotReachedGoalWhenBehind [
    | board spaceship |

    board := Board of: 10 andWormholeAt: #().

    spaceship := Spaceship withName: 'Endeavour'.
    spaceship moveTo: 9.

    self deny: (spaceship hasReachedGoalOn: board).
]

{ #category : 'tests - instance' }
SpaceshipTest >> testHasReachedGoalWhenAtGoal [
    | board spaceship |

    board := Board of: 10 andWormholeAt: #().

    spaceship := Spaceship withName: 'Orion'.

    spaceship moveTo: 10.

    self assert: (spaceship hasReachedGoalOn: board).
]

{ #category : 'tests - instance' }
SpaceshipTest >> testIncreaseMaxFuelByAddsAmount [
    | ship |

    ship := Spaceship withName: 'Booster'.
    ship maxFuel: 4.
    ship increaseMaxFuelBy: 3.

    self assert: ship maxFuel equals: 7.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testInitializeInPositionZero [
    | player |

    player := Spaceship withName: 'JohnDoe'.

    self assert: player position equals: 0.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testInitializeWithEmptyNameRaisesError [
    self should: [ Spaceship withName: '' ] raise: Error.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testIsPenalizedDelegatesToState [
    | ship |

    ship := Spaceship withName: 'Voyager'.
    self deny: ship isPenalized.
    ship penalizeFor: 2.

    self assert: ship isPenalized.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testLapAccessorReturnsCurrentValue [
    | ship |

    ship := Spaceship withName: 'Lapper'.
    ship lap: 2.

    self assert: ship lap equals: 2.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testMoveBackDoesNotGoBelowZero [
    | ship |

    ship := Spaceship withName: 'Probe'.
    ship moveBack: 5.

    self assert: ship position equals: 0.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testMoveForwardIncreasesPosition [
    | ship |

    ship := Spaceship withName: 'Runner'.
    ship moveForward: 3.

    self assert: ship position equals: 3.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testMoveToChangesPosition [
    | ship |

    ship := Spaceship withName: 'Move'.
    ship moveTo: 5.

    self assert: (ship position) equals: 5.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testNameReturnsGivenName [
    | ship |

    ship := Spaceship withName: 'Named'.

    self assert: ship name equals: 'Named'.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testPenalizeForChangesState [
    | ship |

    ship := Spaceship withName: 'Galactica'.
    ship penalizeFor: 3.

    self assert: ship state class equals: PenalizedShipState.
    self assert: ship penaltyTurnsRemaining equals: 3.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testPenaltyTurnsRemainingDelegatesToState [
    | ship |

    ship := Spaceship withName: 'Odyssey'.
    ship penalizeFor: 5.

    self assert: ship penaltyTurnsRemaining equals: 5.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testPlayCardNotInHandRaisesError [
    | ship otherShip card board dice game |

    ship := Spaceship withName: 'Player'.
    otherShip := Spaceship withName: 'Other'.
    card := AdvanceCard new.
    board := Board of: 5 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship. otherShip } board: board dice: dice laps: 1.

    self should: [ ship playCard: card inGame: game ] raise: Error.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testPlayCardRemovesFromHandAndRecords [
    | ship otherShip card board dice game |

    ship := Spaceship withName: 'Player'.
    otherShip := Spaceship withName: 'Other'.
    card := AdvanceCard new.
    ship addCard: card.
    board := Board of: 5 andWormholeAt: #().
    dice := DiceCup with: { Die withSides: 1 }.
    game := Game startWithShips: { ship. otherShip } board: board dice: dice laps: 1.

    ship playCard: card inGame: game.

    self deny: (ship cards includes: card).
    self assert: game lastCardPlayed equals: card.
    self assert: ship position equals: 1.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testReducePenaltyRemovesPenaltyWhenTurnsFinish [
    | ship |

    ship := Spaceship withName: 'Apollo'.
    ship penalizeFor: 1.
    ship reducePenalty.

    self assert: ship state class equals: NormalShipState.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testRemoveCardRemovesFromHand [
    | ship card |

    ship := Spaceship withName: 'Remover'.
    card := AdvanceCard new.
    ship addCard: card.
    ship removeCard: card.

    self deny: (ship cards includes: card).
]

{ #category : 'tests - instance' }
SpaceshipTest >> testRestoreFuelRestoresToMax [
    | ship |

    ship := Spaceship withName: 'Tank'.
    ship restoreFuel.

    self assert: ship fuel equals: ship maxFuel.
]

{ #category : 'tests - instance' }
SpaceshipTest >> testStateSetterChangesState [
    | ship newState |

    ship := Spaceship withName: 'Pegasus'.
    newState := PenalizedShipState forTurns: 1.
    ship state: newState.

    self assert: ship state equals: newState.
]
