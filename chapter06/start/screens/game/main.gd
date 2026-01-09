extends Node

const PORT: int = 7890

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
	_game_over_menu.set_score(floori(_time))
	_game_over_menu.show()
	_enemy_spawner.stop_spawn_timer()
	_health_potion_spawner.stop_spawn_timer()
	HighscoreManager.set_new_highscore(floori(_time))

func host_game() -> void:
	var peer: MultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)

	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		print("Failed to host game")
		return

	multiplayer.multiplayer_peer = peer

func connect_to_game(ip: String) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)

	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		print("Failed to connect to game")
		return

	multiplayer.multiplayer_peer = peer
