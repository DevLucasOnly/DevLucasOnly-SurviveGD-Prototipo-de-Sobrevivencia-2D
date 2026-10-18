# SurviveGD

**[🎮 JOGAR ONLINE NO NAVEGADOR](https://devlucasonly.github.io/DevLucasOnly-SurviveGD-Prototipo-de-Sobrevivencia-2D/)**

Protótipo de jogo de sobrevivência 2D top-down desenvolvido no Godot 4. O projeto implementa mecânicas de combate com projéteis, inteligência artificial de perseguição e gestão centralizada de múltiplos recursos vitais. Estrutura arquitetural baseada em máquina de estados e Autoloads, com controle de versão via Git.

## 🛠️ Tecnologias
*   **Engine:** Godot Engine 4.x
*   **Linguagem:** GDScript

## 🎯 Escopo (MVP)
* **Controle e Animação:** Movimentação bidimensional em 4 direções com máquina de estados (Idle, Move, Dead) e atualização direcional de sprites.

* **Sistema Duplo de Recursos (GameManager):**
   * Humanidade: Decaimento temporal contínuo. Restaurada via coleta de itens (Antídotos). Zera resulta em Game Over.
   * Vida Física: Sistema de acertos (HP). Reduzida ao sofrer dano. Zera resulta em Game Over.

* **Combate:** Sistema de disparo de projéteis instanciados com trajetória calculada pelo vetor direcional do cursor do mouse. Partículas sem cálculo de oclusão de sombras para otimização de renderização.

* **IA Inimiga:** Perseguição vetorial baseada em distância. Implementação de limite de aproximação de colisão e cooldown de ataque para evitar sobreposição ao jogador. Escalonamento de velocidade atrelado ao tempo de sobrevivência e dificuldade global.

* **Feedback de Impacto (Game Feel):** Implementação de Camera Shake, vibração de comando, Freeze Frame (manipulação de time_scale), Sprite Flashing para invulnerabilidade e emissores de partículas (GPUParticles2D) com textura animada para impactos.

* **Cenário:** Mapa estático (Sprite2D) com colisões manuais (StaticBody2D) controladas rigorosamente via Layers e Masks físicas. Implementação de ambiente escuro (CanvasModulate) e iluminação radial focal com oclusão de sombras em obstáculos geométricos (LightOccluder2D).

* **Persistência de Dados:**
    * High Score: Calculado através da equação de tempo de sobrevivência, inimigos eliminados e multiplicador de dificuldade. Gravado no disco via FileAccess.
    * Configurações: Persistência de volumes de áudio (barramentos de som) e resoluções de tela via ConfigFile.

## 🚀 Como Executar

### Jogar no Navegador (Recomendado)
Acesse o link do GitHub Pages no topo deste documento para jogar a versão mais recente em HTML5/WebAssembly diretamente no navegador, sem necessidade de download.

### Executar Localmente (Código Fonte)
1. Clone este repositório:
   `git clone https://github.com/DevLucasOnly/DevLucasOnly-SurviveGD-Prototipo-de-Sobrevivencia-2D.git`
2. Abra o Godot Engine (versão 4.x).
3. Importe o projeto selecionando o arquivo `project.godot` na pasta do jogo.
4. Pressione `F5` para compilar e executar a cena principal.

## 📂 Estrutura do Repositório
*   `/.godot/` - Ignorado via `.gitignore`.
*   `/assets/` - Texturas e formas geométricas básicas.
*   `/audio/` - Ficheiros de áudio para o jogo.
*   `/autoloads/` - Ficheiros GDScript globais.
*   `/docs/` - Ficheiros de build da exportação Web (HTML5) para o GitHub Pages.
*   `/proposta/` - Documentação acadêmica (Proposta `.docx`, GDD e diagramas de modelagem de cenas/classes).
*   `/scenes/` - Cenas do jogo (World, Player, Enemy, HUD).
*   `/scripts/` - Arquivos GDScript isolados por nó funcional.

## 🔄 Status do Projeto
MVP Finalizado. Ciclo de polimento concluído com a integração do mapa estático com colisões em camada, sistema de iluminação e sombras dinâmicas, refinamento vetorial do combate corpo a corpo, persistência de dados estruturada e compilação para Web. Versão estável.
