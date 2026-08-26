# SurviveGD

Protótipo de jogo de sobrevivência 2D top-down focado em implementação lógica, cálculo vetorial bidimensional e controle de versão. Projeto acadêmico desenvolvido para avaliação de arquitetura de software e versionamento via Git.

## 🛠️ Tecnologias
*   **Engine:** Godot Engine 4.x
*   **Linguagem:** GDScript

## 🎯 Escopo (MVP)
*   Movimentação vetorial do jogador (eixos X e Y).
*   Sistema de energia com decaimento constante ao longo do tempo.
*   Coleta de recursos para restauração de energia (Overlap/Colisão).
*   IA inimiga de perseguição linear baseada em distância euclidiana.
*   Uso de *sprites* geométricos provisórios/livres para foco exclusivo na programação.

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

## 🔄 Status do Projeto
Em desenvolvimento. Ciclo planejado de 8 semanas com estruturação baseada em *branches* modulares e *commits* atômicos.
