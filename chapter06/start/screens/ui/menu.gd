extends Control

const PORT: int = 7890

@onready var _highscore_label: Label = $CenterContainer/MainUIContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HighscoreLabel
@onready var _server_line_edit: LineEdit = $CenterContainer/MainUIContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/ServerLineEdit

func _on_play_button_pressed():
	if _server_line_edit.text.is_empty():
		host_game()
	else:
		connect_to_game(_server_line_edit.text)

	get_tree().change_scene_to_file("res://screens/game/main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _ready():
	_highscore_label.text = str(HighscoreManager.highscore)
	if multiplayer.has_multiplayer_peer():
		multiplayer.multiplayer_peer.close()

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
