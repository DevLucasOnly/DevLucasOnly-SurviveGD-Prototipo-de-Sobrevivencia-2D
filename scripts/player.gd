extends CharacterBody2D

enum Estado {IDLE, MOVE, DEAD}
var estado_atual: Estado = Estado.IDLE
var direcao_atual: String = "down" 
var invulneravel: bool = false

@export var speed: float = 300.0
@export var projetil_cena: PackedScene 

# Referência unificada para o AnimatedSprite2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var muzzle: Marker2D = $Muzzle 
@onready var timer_invulnerabilidade: Timer = $TimerInvulnerabilidade
@onready var vfx_tiro: GPUParticles2D = $Muzzle/GPUParticles2D
@onready var vfx_dano: GPUParticles2D = $VFXDano
@onready var sfx_andar: AudioStreamPlayer2D = $SfxAndar
@onready var sfx_dano_jogador: AudioStreamPlayer2D = $SfxDano
@onready var pivot_apontador: Node2D = $PivotApontador

var shake_intensity: float = 0.0
const SHAKE_DECAY: float = 10.0
var tween_invulnerabilidade: Tween # Variável para gerir a animação de dano

func _ready() -> void:
    GameManager.humanidade_alterada.connect(_on_humanidade_alterada)
    GameManager.game_over.connect(_on_game_over)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("atirar") and estado_atual != Estado.DEAD:
        atirar()

func _process(delta: float) -> void:
    atualizar_apontador()
    if shake_intensity > 0:
        shake_intensity = lerpf(shake_intensity, 0.0, SHAKE_DECAY * delta)
        camera.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * shake_intensity
    else:
        camera.offset = Vector2.ZERO

func _physics_process(_delta: float) -> void:
    match estado_atual:
        Estado.IDLE:
            _estado_idle()
        Estado.MOVE:
            _estado_move()
        Estado.DEAD:
            _estado_dead()

    move_and_slide()

    if velocity.length() > 0:
        if not sfx_andar.playing:
            sfx_andar.play()
    else:
        sfx_andar.stop()

func _estado_idle() -> void:
    velocity = Vector2.ZERO
    anim.play("idle_" + direcao_atual)
    
    var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if input_direction != Vector2.ZERO:
        estado_atual = Estado.MOVE

func _estado_move() -> void:
    var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = input_direction * speed
    
    if velocity == Vector2.ZERO:
        estado_atual = Estado.IDLE
    else:
        var angulo = velocity.angle()
        var indice = int(snapped(angulo, PI/4) / (PI/4))
        
        if indice < 0:
            indice += 8
            
        var array_direcoes = ["right", "down_right", "down", "down_left", "left", "up_left", "up", "up_right"]
        direcao_atual = array_direcoes[indice]
        
        anim.play("walk_" + direcao_atual)

func _estado_dead() -> void:
    velocity = Vector2.ZERO
    anim.play("idle_down")

func atirar() -> void:
    if projetil_cena == null:
        print("[ERRO] Cena do projétil não atribuída no Inspector do Player.")
        return
        
    var tiro = projetil_cena.instantiate()
    get_tree().current_scene.add_child(tiro) 
    tiro.global_position = muzzle.global_position
    
    var direcao_mira = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
    var vetor_final: Vector2
    
    if direcao_mira != Vector2.ZERO:
        vetor_final = direcao_mira.normalized()
    else:
        vetor_final = (get_global_mouse_position() - global_position).normalized()
    
    tiro.direction = vetor_final
    tiro.rotation = vetor_final.angle()
    
    vfx_tiro.global_rotation = vetor_final.angle()
    vfx_tiro.restart()

func acionar_feedback_dano() -> void:
    shake_intensity = 15.0
    
    Engine.time_scale = 0.0
    await get_tree().create_timer(0.05, true, false, true).timeout
    Engine.time_scale = 1.0

func _on_humanidade_alterada(_valor: float) -> void:
    pass 

func _on_game_over() -> void:
    estado_atual = Estado.DEAD
    invulneravel = true # Previne qualquer nova colisão
    
    if tween_invulnerabilidade:
        tween_invulnerabilidade.kill()
    anim.modulate.a = 1.0

func receber_dano(quantidade: int) -> void:
    if estado_atual == Estado.DEAD or invulneravel:
        return

    invulneravel = true
    timer_invulnerabilidade.start()

    # A verificação de morte e pontuação já ocorre dentro desta função no GameManager
    GameManager.aplicar_dano_jogador(quantidade)
    
    acionar_feedback_dano()
    _acionar_efeito_invulnerabilidade()
    vfx_dano.restart()

    Input.start_joy_vibration(0, 0.4, 1.0, 0.25)
    sfx_dano_jogador.play()

func _acionar_efeito_invulnerabilidade() -> void:
    if tween_invulnerabilidade:
        tween_invulnerabilidade.kill()
        
    tween_invulnerabilidade = create_tween().set_loops()
    tween_invulnerabilidade.tween_property(anim, "modulate:a", 0.3, 0.1)
    tween_invulnerabilidade.tween_property(anim, "modulate:a", 1.0, 0.1)
    
    await timer_invulnerabilidade.timeout
    
    if tween_invulnerabilidade:
        tween_invulnerabilidade.kill()
        
    anim.modulate.a = 1.0
    
    if estado_atual != Estado.DEAD:
        invulneravel = false

func atualizar_apontador() -> void:
    var itens_alvo = get_tree().get_nodes_in_group("antidoto")
    
    if itens_alvo.is_empty():
        pivot_apontador.visible = false
        return
        
    var alvo_mais_proximo: Node2D = null
    var menor_distancia: float = INF
    
    for alvo in itens_alvo:
        if not is_instance_valid(alvo) or alvo.is_queued_for_deletion():
            continue
            
        var distancia = global_position.distance_to(alvo.global_position)
        if distancia < menor_distancia:
            menor_distancia = distancia
            alvo_mais_proximo = alvo
            
    if alvo_mais_proximo:
        pivot_apontador.visible = true
        pivot_apontador.look_at(alvo_mais_proximo.global_position)
    else:
        pivot_apontador.visible = false