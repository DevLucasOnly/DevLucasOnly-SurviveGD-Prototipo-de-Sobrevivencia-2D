extends CharacterBody2D

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sfx_impacto: AudioStreamPlayer2D = $SfxImpacto

@export var velocidade_base: float = 70.0
@export var vida_maxima: int = 3

var em_cooldown: bool = false
var alvo: Node2D
var vida_atual: int

func _ready() -> void:
    # Aplica o bónus de vida definido no GameManager com base na dificuldade
    vida_atual = vida_maxima + GameManager.inimigo_vida_bonus
    alvo = get_tree().get_first_node_in_group("jogador")

func _physics_process(_delta: float) -> void:
    # 1. Movimentação (Apenas se houver alvo, humanidade e não estiver em cooldown)
    if alvo and GameManager.humanidade_atual > 0.0 and not em_cooldown:
        var distancia = global_position.distance_to(alvo.global_position)
        var distancia_de_ataque = 15.0 # Ajuste este valor conforme o tamanho da sua Hitbox
        
        if distancia > distancia_de_ataque:
            var escalonamento_temporal = 1.0 + (GameManager.tempo_sobrevivencia * 0.0015) 
            escalonamento_temporal = min(escalonamento_temporal, 2.0)
            
            var velocidade_atual = velocidade_base * escalonamento_temporal * GameManager.multiplicador_dificuldade
            var direcao = global_position.direction_to(alvo.global_position)
            velocity = direcao * velocidade_atual
        else:
            # Zera a velocidade ao atingir a distância de ataque para não empurrar o jogador
            velocity = Vector2.ZERO
    else:
        # Fica imóvel durante o cooldown ou se o jogador morrer
        velocity = Vector2.ZERO
        sfx_player.stop()

    move_and_slide()
    
    if velocity != Vector2.ZERO:
        acionar_som_sfx()
        atualizar_direcao_visual()
        
    # 2. Detecção de Dano Contínua (Substitui o sinal _on_hitbox_body_entered)
    if alvo and not em_cooldown:
        for body in $Hitbox.get_overlapping_bodies():
            if body.is_in_group("jogador"):
                if body.has_method("receber_dano"):
                    body.receber_dano(1 * GameManager.multiplicador_dano_jogador)
                    _iniciar_pausa_pos_ataque()

func atualizar_direcao_visual() -> void:
    if abs(velocity.x) > abs(velocity.y):
        if velocity.x > 0:
            anim.play("right")
        else:
            anim.play("left")
    elif velocity.y > 0:
        anim.play("down")
    else:
        anim.play("up")

func acionar_som_sfx() -> void:
    if not sfx_player.playing:
        sfx_player.play()

func receber_dano(quantidade: int) -> void:
    vida_atual -= quantidade
    sfx_impacto.play()
    if vida_atual <= 0:
        morrer()
    else:
        piscar_dano()

func piscar_dano() -> void:
    if sprite:
        sprite.modulate = Color(10, 10, 10) 
        await get_tree().create_timer(0.1, false).timeout
        
        if is_instance_valid(sprite):
            sprite.modulate = Color(1, 1, 1)

func morrer() -> void:
    GameManager.registrar_morte_inimigo()
    queue_free()

func _iniciar_pausa_pos_ataque() -> void:
    em_cooldown = true
    
    # Pausa o inimigo por 1 segundo após acionar o dano
    await get_tree().create_timer(1.0, false).timeout 
    
    em_cooldown = false