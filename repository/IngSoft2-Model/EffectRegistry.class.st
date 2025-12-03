Class {
	#name : 'EffectRegistry',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
EffectRegistry class >> effectDistribution [
	
	
	
	
	
	
	^ OrderedCollection new
		add: ([ NoEffect new ] -> GameRules noEffectWeight);
		add: ([ CardEffect new ] -> GameRules cardEffectWeight);
		add: ([ BlackHoleEffect new ] -> GameRules blackHoleEffectWeight);
		add: ([ HyperGravityEffect new ] -> GameRules hyperGravityEffectWeight);
		add: ([ MoonWalkEffect new ] -> GameRules moonWalkEffectWeight);
		add: ([ HyperJumpEffect withValues: #(1 2 3) ] -> GameRules hyperJumpEffectWeight);
		add: ([ AtomicBombEffect new ] -> GameRules atomicBombEffectWeight);
		yourself
]

{ #category : 'accessing' }
EffectRegistry class >> allEffectTypes [
	
	
	^ OrderedCollection new
		add: NoEffect;
		add: CardEffect;
		add: BlackHoleEffect;
		add: HyperGravityEffect;
		add: MoonWalkEffect;
		add: HyperJumpEffect;
		add: AtomicBombEffect;
		yourself
]

{ #category : 'querying' }
EffectRegistry class >> effectCount [
	
	^ self allEffectTypes size
]

{ #category : 'querying' }
EffectRegistry class >> hasEffectType: anEffectClass [
	
	^ self allEffectTypes includes: anEffectClass
]

{ #category : 'querying' }
EffectRegistry class >> totalWeight [
	
	
	^ self effectDistribution 
		inject: 0 
		into: [ :sum :assoc | sum + assoc value ]
]
