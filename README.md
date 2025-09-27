# Análise de Dados Pokémon com R

## 📄 Sobre o Projeto

Este repositório contém uma análise de dados detalhada sobre Pokémon, utilizando um dataset de 1.025 criaturas retirado do Kaggle. O objetivo do projeto é explorar as diversas características dos Pokémon, como seus tipos, estatísticas de combate, geração e grupos especiais, a fim de identificar padrões e relações.

A análise foi conduzida em R e documentada utilizando Quarto. O processo inclui desde a limpeza e tratamento dos dados até a aplicação de um modelo de classificação para prever se um Pokémon pertence a um grupo especial (Lendário, Mítico, etc.).

## 📋 Tabela de Conteúdos
-   Principais Descobertas
-   Tecnologias Utilizadas
-   Estrutura da Análise
-   Como Executar o Projeto
-   Fonte dos Dados

## ✨ Principais Descobertas
### Análise Exploratória
-   **Distribuição de Tipos:** Os tipos **Água**, **Normal** e **Grama** são os mais frequentes como tipo primário. Curiosamente, 50% dos Pokémon não possuem um tipo secundário ("Nenhum").
-   **Os Mais Fortes vs. Os Mais Fracos:** Pokémon como **Arceus** (total 720) e **Eternatus** (total 680) estão no topo em poder. Todos os Pokémon mais fortes possuem uma taxa de crescimento "Lenta". Em contraste, os mais
  fracos, como **Wishiwashi** (total 175), têm taxas de crescimento variadas.
-   **Facilidade de Captura:** Pokémon lendários como **Articuno** e **Mewtwo** têm a menor taxa de captura (3) , enquanto Pokémon comuns como 
**Caterpie** e **Pidgey** têm a maior (255)
-   **Análise por Geração:** As gerações **1**, **3** e **5** são as que mais introduziram novos Pokémon. Apesar disso, o poder total médio dos Pokémon se mantém equilibrado entre as gerações mais antigas e as mais recentes.

### Modelo de Classificação
Um modelo de árvore de decisão 
**C5.0** foi treinado para classificar os Pokémon entre os grupos "Ordinary" e "Especiais".
O modelo alcançou uma 
**acurácia de 98%** na base de teste, demonstrando alta capacidade preditiva.
As variáveis mais importantes para a classificação foram: 
`egg_group1`, `egg_cycles` e `catch_rate`, indicando que os ciclos de ovo e a dificuldade de captura são fortes indicadores de um Pokémon especial.

## 🚀 Tecnologias Utilizadas
-   Linguagem: R
-   Documentação: Quarto
-   Pacotes Principais: `tidyverse`, `dplyr`, `gtsummary`, `caret`, `C5.0`, `ggplot2`.

## ⚙️ Estrutura da Análise
A análise foi dividida nas seguintes etapas:
1.  **Tratamento e Limpeza de Dados:** Verificação de duplicatas, remoção de espaços em branco, substituição de valores ausentes (representados por `""`) por "Nenhum" e conversão dos tipos de variáveis para `factor`, `integer` e `double` para facilitar a análise.

2.  **Análise Exploratória de Dados (AED):** Utilização de estatísticas descritivas e testes estatísticos (Kolmogorov-Smirnov e Levene) para entender a distribuição dos dados. Visualizações como histogramas, gráficos de barras e de violino foram criadas para comparar as características dos Pokémon.

4.  **Modelo de Classificação:** Pré-processamento dos dados, incluindo a transformação da variável-alvo `special_group` em uma categoria binária ("Especiais" e "Ordinary"). Aplicação do algoritmo C5.0, avaliação da performance do modelo com matriz de confusão e identificação dos atributos mais importantes.

## 🔧 Como Executar o Projeto
1.  **Clone o repositório:**
```bash
git clone https://github.com/seu-usuario/seu-repositorio.git
```
2.  **Abra o projeto no RStudio.**
3.  **Instale as dependências.** O código a seguir, presente no relatório, instala todos os pacotes necessários:
```
pacotes = c("tidyverse","C50","gmodels","dplyr","knitr","gtsummary","caret","car","stats")

pacotes_nao_instalados = pacotes[!(pacotes %in% installed.packages()[, "Package"])]

if (length(pacotes_nao_instalados) > 0) {
  install.packages(pacotes_nao_instalados)
}

lapply(pacotes, library, character.only = TRUE)
```

4.  **Execute o arquivo** `.qmd` para renderizar o relatório HTML completo.

### 📊 Fonte dos Dados
O conjunto de dados utilizado neste projeto está disponível publicamente no Kaggle:
-   [Pokemon Stats (1025 pokemons)](https://www.kaggle.com/datasets/guavocado/pokemon-stats-1025-pokemons)



