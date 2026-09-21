# SurviveGD

Protótipo de jogo de sobrevivência 2D top-down desenvolvido no Godot 4. O projeto implementa mecânicas de combate com projéteis, inteligência artificial de perseguição e gestão centralizada de múltiplos recursos vitais. Estrutura arquitetural baseada em máquina de estados e Autoloads, com controle de versão via Git.

## 🛠️ Tecnologias
*   **Engine:** Godot Engine 4.x
*   **Linguagem:** GDScript

## 🎯 Escopo (MVP)
* **Controle e Animação:** Movimentação bidimensional em 4 direções com máquina de estados (Idle, Move, Dead) e atualização direcional de sprites.

* **Sistema Duplo de Recursos (GameManager):**

   * Humanidade: Decaimento temporal contínuo. Restaurada via coleta de itens (Antídotos). Zera resulta em Game Over.

   * Vida Física: Sistema de acertos (HP). Reduzida ao sofrer dano. Zera resulta em Game Over.

* **Combate:** Sistema de disparo de projéteis instanciados com trajetória calculada pelo vetor direcional do cursor do mouse.

* **IA Inimiga:** Perseguição contínua baseada em distância vetorial, atualização direcional visual em tempo real e sistema de saúde (destruição após 3 acertos).

* **Feedback de Impacto (Game Feel):** Implementação de Camera Shake, Freeze Frame (manipulação de time_scale) e Sprite Flashing (manipulação de modulate) durante o recebimento de dano.

* **Cenário:** Estruturação de mapas via TileMap com camadas de física (Physics Layers) para colisão rigorosa.

* **Persistência de Dados:** Sistema de High Score baseado em tempo de sobrevivência, salvo e carregado localmente no disco.

## 🚀 Como Executar
1. Clone este repositório:
   `git clone https://github.com/DevLucasOnly/DevLucasOnly-SurviveGD-Prototipo-de-Sobrevivencia-2D.git`
2. Abra o Godot Engine (versão 4.x).
3. Importe o projeto selecionando o arquivo `project.godot` na pasta do jogo.
4. Pressione `F5` para compilar e executar a cena principal.

## 📂 Estrutura do Repositório
*   `/.godot/` - Ignorado via `.gitignore`.
*   `/assets/` - Texturas e formas geométricas básicas.
*   `/proposta/` - Documentação acadêmica (Proposta `.docx`, GDD e diagramas de modelagem de cenas/classes).
*   `/scenes/` - Cenas do jogo (World, Player, Enemy, HUD).
*   `/scripts/` - Arquivos GDScript isolados por nó funcional.
*   `/autoloads/` - Arquivos GDScript globais.
*   `/audio/` - Arquivos de audio para o game.
  ## 🔄 Status do Projeto
Em desenvolvimento. Transição concluída de gráficos provisórios (formas geométricas) para pixel art definitiva e implementação base de combate finalizada. Foco atual no mapeamento de colisões de cenário e balanceamento dos vetores de dano.
