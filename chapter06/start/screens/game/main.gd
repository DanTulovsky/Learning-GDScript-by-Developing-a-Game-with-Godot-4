extends Node

@export var player_scene: PackedScene

# multiplayer
@onready var _player_multiplayer_spawner: MultiplayerSpawner = $PlayerMultiplayerSpawner
@onready var _player_start_positions: Node2D = $PlayerStartPositions
var _player_spawn_index: int = 0
# end multiplayer

@onready var _game_over_menu: CenterContainer = $CanvasLayer/GameOverMenu
@onready var _enemy_spawner: EntitySpawner = $EnemySpawner
@onready var _health_potion_spawner: EntitySpawner = $HealthPotionSpawner
@onready var _time_label: Label = $CanvasLayer/TimerUI/TimerLabel


var _time: float = 0:
	set(value):
		_time = value
		_time_label.text = "{0} s".format([floorf(_time)])

func _process(delta: float) -> void:
	_time += delta

func _on_player_died() -> void:
	end_game.rpc()

@rpc("authority", "reliable", "call_local")
func end_game():
	_game_over_menu.set_score(floori(_time))
	_game_over_menu.show()
	_enemy_spawner.stop_spawn_timer()
	_health_potion_spawner.stop_spawn_timer()
	HighscoreManager.set_new_highscore(floori(_time))

func add_player(id: int) -> void:
	_player_multiplayer_spawner.spawn(id)

func spawn_player(id: int) -> Player:
	var player: Player = player_scene.instantiate()
	player.multiplayer_id = id
	player.died.connect(_on_player_died)

	var spawn_marker: Marker2D = _player_start_positions.get_child(_player_spawn_index)
	player.position = spawn_marker.position
	_player_spawn_index = (_player_spawn_index + 1) % _player_start_positions.get_child_count()

	return player

func _ready() -> void:
	_player_multiplayer_spawner.spawn_function = spawn_player

	if multiplayer.is_server():
		multiplayer.peer_connected.connect(add_player)
		add_player(1)
	else:
		set_process(false)
