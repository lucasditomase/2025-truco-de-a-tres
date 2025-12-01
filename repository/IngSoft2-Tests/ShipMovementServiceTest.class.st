Class {
    #name : 'ShipMovementServiceTest',
    #superclass : 'TestCase',
    #category : 'IngSoft2-Tests',
    #package : 'IngSoft2-Tests'
}

{ #category : 'helpers' }
ShipMovementServiceTest >> buildServiceStartingAt: startPosition cellCount: count [
    | ship manager service |
    ship := Spaceship withName: 'Mover'.
    ship moveTo: startPosition.
    manager := PositionManager forShips: { ship }.
    service := ShipMovementService
        withPositionManager: manager
        cellCount: count
        lastMoves: Dictionary new.
    ^ { service. ship. manager }
]

{ #category : 'tests' }
ShipMovementServiceTest >> testMoveShipForwardUpdatesPositionAndLastMove [
    | tuple service ship manager |
    tuple := self buildServiceStartingAt: 0 cellCount: 10.
    service := tuple first.
    ship := tuple second.
    manager := tuple third.

    service moveShip: ship forward: 3.

    self assert: (manager positionOf: ship) equals: 3.
    self assert: (service lastMoveFor: ship) equals: 3.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testMoveShipBackwardWrapsAndRecordsNegativeDelta [
    | tuple service ship manager |
    tuple := self buildServiceStartingAt: 1 cellCount: 5.
    service := tuple first.
    ship := tuple second.
    manager := tuple third.

    service moveShip: ship backward: 3.

    self assert: (manager positionOf: ship) equals: 3.
    self assert: (service lastMoveFor: ship) equals: -3.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testMoveShipToUsesAbsoluteDestination [
    | tuple service ship manager |
    tuple := self buildServiceStartingAt: 2 cellCount: 10.
    service := tuple first.
    ship := tuple second.
    manager := tuple third.

    service moveShip: ship to: 7.

    self assert: (manager positionOf: ship) equals: 7.
    self assert: (service lastMoveFor: ship) equals: 5.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testClearLastMovesResetsHistory [
    | tuple service ship |
    tuple := self buildServiceStartingAt: 0 cellCount: 10.
    service := tuple first.
    ship := tuple second.

    service moveShip: ship forward: 4.
    service clearLastMoves.

    self assert: (service lastMoveFor: ship) equals: 0.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testRecentMovesDuringCapturesAggregatedReport [
    | tuple service ship report captured |
    tuple := self buildServiceStartingAt: 0 cellCount: 8.
    service := tuple first.
    ship := tuple second.

    captured := service recentMovesDuring: [
        service moveShip: ship forward: 7.
        service moveShip: ship backward: 2
    ].
    report := captured at: ship ifAbsent: [ self fail: 'Missing report' ].

    self assert: report startPosition equals: 0.
    self assert: report delta equals: 5.

    service moveShip: ship forward: 1.
    self assert: report delta equals: 5.
]

{ #category : 'tests' }
ShipMovementServiceTest >> testIsRecordingMovesOnlyDuringCapture [
    | tuple service flag |
    tuple := self buildServiceStartingAt: 0 cellCount: 3.
    service := tuple first.
    flag := false.

    service recentMovesDuring: [ flag := service isRecordingMoves ].

    self assert: flag.
    self deny: service isRecordingMoves.
]
