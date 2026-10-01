extends Node

signal humanidade_alterada(novo_valor: float)
signal vida_alterada(novo_valor: int) 
signal tempo_atualizado(novo_tempo: int)
signal game_over

const SAVE_PATH: String = "user://highscore.save"
const ARQUIVO_CONFIG: String = "user://settings.cfg"

var humanidade_maxima: float = 100.0
var humanidade_atual: float = 100.0
var tempo_sobrevivencia: float = 0.0
var taxa_decaimento: float = 5.0 
var multiplicador_dificuldade: float = 1.0

var vida_maxima: int = 3
var vida_atual: int = 3

var high_score: int = 0
var jogo_ativo: bool = true 

var bgm_player: AudioStreamPlayer

func _ready() -> void:
	humanidade_atual = humanidade_maxima
	vida_atual = vida_maxima
	carregar_high_score()
	
	# Instancia e configura a música de fundo dinamicamente
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	bgm_player.bus = "BGM"
	bgm_player.stream = preload("res://audio/Ultimo_Sinal_SurviveGD.ogg") # ATENÇÃO: Atualize este caminho
	bgm_player.play()
	
	_carregar_configuracoes_globais()

func _process(delta: float) -> void:
	if not jogo_ativo:
		return

	if humanidade_atual > 0.0:
		humanidade_atual -= taxa_decaimento * delta
		humanidade_alterada.emit(humanidade_atual)
		
		tempo_sobrevivencia += delta
		tempo_atualizado.emit(int(tempo_sobrevivencia))
		
		if humanidade_atual <= 0.0:
			humanidade_atual = 0.0
			encerrar_jogo()

func aplicar_dano_jogador(quantidade: int) -> void:
	if not jogo_ativo:
		return
		
	vida_atual -= quantidade
	vida_alterada.emit(vida_atual)
	
	if vida_atual <= 0:
		vida_atual = 0
		encerrar_jogo()

func encerrar_jogo() -> void:
	jogo_ativo = false
	set_process(false)
	
	var tempo_inteiro = int(tempo_sobrevivencia)
	if tempo_inteiro > high_score:
		high_score = tempo_inteiro
		salvar_high_score()
		
	print("[DEBUG] GameManager emitiu game_over")
	game_over.emit()

func restaurar_humanidade(quantidade: float) -> void:
	if jogo_ativo and humanidade_atual > 0.0:
		humanidade_atual = clamp(humanidade_atual + quantidade, 0.0, humanidade_maxima)
		humanidade_alterada.emit(humanidade_atual)

func resetar_estado() -> void:
	humanidade_atual = humanidade_maxima
	vida_atual = vida_maxima
	tempo_sobrevivencia = 0.0
	jogo_ativo = true
	set_process(true)

func salvar_high_score() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(high_score)
		file.close()
		print("[DEBUG] High Score salvo: ", high_score)

func carregar_high_score() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			high_score = file.get_32()
			file.close()
			print("[DEBUG] High Score carregado: ", high_score)

func _carregar_configuracoes_globais() -> void:
	var config = ConfigFile.new()
	if config.load(ARQUIVO_CONFIG) == OK:
		# Aplica os volumes guardados
		var master_bus = AudioServer.get_bus_index("Master")
		var bgm_bus = AudioServer.get_bus_index("BGM")
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(config.get_value("Audio", "master", 0.8)))
		AudioServer.set_bus_volume_db(bgm_bus, linear_to_db(config.get_value("Audio", "bgm", 0.8)))
		
		# Aplica as configurações de ecrã inteiro
		var modo_fullscreen = config.get_value("Video", "fullscreen", false)
		if modo_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		var diff = config.get_value("Jogo", "dificuldade", 1)
		match diff:
			0: multiplicador_dificuldade = 0.8
			1: multiplicador_dificuldade = 1.0
			2: multiplicador_dificuldade = 1.5

func parar_musica() -> void:
	if bgm_player and bgm_player.playing:
		bgm_player.stop()

func tocar_musica() -> void:
	if bgm_player and not bgm_player.playing:
		bgm_player.play()
