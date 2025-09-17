rm(list = ls())

pacotes = c("tidyverse","C50","gmodels","dplyr")

#install.packages(pacotes)

lapply(pacotes, library, character.only = TRUE)

pokemon = read.csv2("~/R/PROJETOS R/Análise pokemon/pokemon_data.csv", header = T, sep = ",", fileEncoding = "UTF-8")

attach(pokemon)

# Separando ev_yield
pokemon = pokemon |>
  separate(col = ev_yield, into = c("pts. de esforço","pts. de esforço2","pts. de esforço3"),
           sep = ",")


# Substituindo valores "" de dataframe por "Nenhum"

subst_vazios = function(col){
  ifelse(col == "", "Nenhum", col)
}
subst_na = function(col){
  ifelse(is.na(col), "Nenhum", col)
}

pokemon = apply(pokemon, 2, subst_vazios)
pokemon = apply(pokemon, 2, subst_na)

pokemon = as.data.frame(pokemon)


# Alterando o tipo das colunas data pokemon

pokemon$generation = as.factor(generation)
pokemon$base_friendship = as.factor(base_friendship)

pokemon$special_group = as.factor(special_group)

pokemon$egg_cycles = as.factor(egg_cycles)
pokemon$percent_male = as.factor(percent_male)
pokemon$percent_female = as.factor(percent_female)
pokemon$growth_rate = as.factor(growth_rate)

pokemon$height = as.double(height)
pokemon$weight = as.double(weight)
pokemon$hp = as.integer(hp)
pokemon$attack = as.integer(attack)
pokemon$defense = as.integer(defense)
pokemon$sp_atk = as.integer(sp_atk)
pokemon$sp_def = as.integer(sp_def)
pokemon$speed = as.integer(speed)
pokemon$total = as.integer(total)
pokemon$base_exp = as.integer(base_exp)
pokemon$catch_rate = as.integer(catch_rate)
pokemon$base_friendship = as.integer(base_friendship)

str(pokemon)

# Verificando peso medio e altura para cada tipo de pokemon
# Tipo1
pokemon |>
  group_by(type2) |>
  summarise(peso_media = mean(height, na.rm = T),
            altura_media = mean(weight, na.rm = T),
            count = n()) |>
  arrange(desc(peso_media))

# Tipo2
pokemon |>
  group_by(type1) |>
  summarise(peso_media = mean(height, na.rm = T),
            altura_media = mean(weight, na.rm = T),
            count = n())

# 5 Pokemons mais fortes (baseado na coluna total)
pokemon |>
  select(name,total,species,type1,type2,growth_rate) |>
  filter(total>=mean(total)) |>
  arrange(desc(total)) |>
  head(10)


# 5 Pokemons mais fracos (baseado na coluna total)
pokemon |>
  select(name,total,species,type1,type2, growth_rate) |>
  filter(total<mean(total)) |>
  arrange((total)) |>
  head(10)


# 5 pokemons mais difíceis de capturar
pokemon |>
  select(name,catch_rate,species,type1,type2, growth_rate) |>
  filter(catch_rate<mean(catch_rate)) |>
  arrange(catch_rate) |>
  head(10)


# 5 pokemons mais fáceis de capturar
pokemon |>
  select(name,catch_rate,species,type1,type2, growth_rate) |>
  filter(catch_rate>=mean(catch_rate)) |>
  arrange(desc(catch_rate)) |>
  head(5)

# Gráficos

# Distribuição de geração, special_group e growth_rate
ggplot(data = pokemon) +
  geom_bar(aes(x = generation, fill = "steelblue")) +
  labs(title = "Quantidade de Pokémon por Geração", x = "Geração", y = "Frequência") +
  theme_minimal()

ggplot(data = pokemon) +
  geom_bar(aes(x = growth_rate, fill = "tomato")) + scale_y_log10() +
  labs(title = "Quantidade de Pokémon por Taxa de Crescimento", x = "Taxa de Crescimento", y = "Frequência") +
  theme_minimal()

ggplot(data = pokemon) +
  geom_bar(aes(x = special_group, fill = "darkgreen"),width = 0.6) + scale_y_log10() +
  labs(title = "Quantidade de Pokémon por Grupo Especial", x = "Grupos Especiais", y = "Frequência") +
  theme_minimal()


# Distribuição do tipo1
pokemon %>%
  count(type1) %>%
  ggplot(aes(x = reorder(type1, n), y = n, fill = type1)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Distribuição do Tipo1 de Pokémon", x = "Tipo1", y = "Frequência") +
  theme_minimal()

# Distribuição do tipo2
pokemon %>%
  count(type2) %>%
  ggplot(aes(x = reorder(type2, n), y = n, fill = type2)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Distribuição do Tipo2 de Pokémon", x = "Tipo2", y = "Frequência") +
  theme_minimal()

# Distribuição do total
ggplot(pokemon, aes(x = total)) +
  geom_histogram(bins = 30, fill = "orange", color = "black") +
  labs(title = "Distribuição do Total de Atributos", x = "Total de Atributos", y = "Frequência") +
  theme_minimal()

# Verificar melhor geração, taxa de crescimento e grupo especial baseado no total

ggplot(pokemon, aes(x = generation, y = total, color=generation)) +
  geom_violin() + stat_summary(fun.y=mean, geom="point", shape=23, size=5, fill = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2))

ggplot(pokemon, aes(x = special_group, y = total, color=special_group)) +
  geom_violin() + stat_summary(fun.y=mean, geom="point", shape=23, size=4, fill = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2))

ggplot(pokemon, aes(x = growth_rate, y = total, color=growth_rate)) +
  geom_violin() + stat_summary(fun.y=mean, geom="point", shape=23, size=4, fill = "black") +
  geom_jitter(shape=16, position=position_jitter(0.2))

# Modelo de Classificação usando arvore de decisão
# variavel preditiva = "special_group"

# Excluindo colunas inutilizáveis para o modelo 
pokemon$name = NULL
pokemon$dexnum = NULL

pokemon$percent_female = NULL
pokemon$percent_male = NULL

pokemon$species = NULL
pokemon$ability1 = NULL
pokemon$ability2 = NULL
pokemon$hidden_ability = NULL

pokemon$ev_yield = NULL

# Mudando special group para dicotomica
pokemon = pokemon |>
  mutate(
    special_group = fct_recode(special_group,
                               "Outro"    = "Future Paradox",
                               "Outro"      = "Ancient Paradox",
                               "Outro" = "Ultra Beast",
                               "Outro" = "Baby Pokemon",
                               "Outro"        = "Fossil",
                               "Outro"      = "Legendary",
                               "Outro"                 = "Mythical",
                               "Ordinary" = "Ordinary"))

# Convertendo letra "é" na coluna species por "e"
#pokemon$species <- gsub("é", "e", pokemon$species, ignore.case = TRUE)

# Omitindo linhas que possuem valores nulos (34 linhas)
pokemon = na.omit(pokemon)

set.seed(123)
amostra_teste = sample(1008,102)

pokemon_treino = pokemon[-amostra_teste,]
pokemon_teste = pokemon[amostra_teste,]

dim(pokemon_treino)
dim(pokemon_teste)

modelo_pokemon = C5.0(x = pokemon_treino[-c(20)], y = pokemon_treino$special_group)

# Vamos ver como o modelo classifica os dados de teste
pokemon_pred = predict(modelo_pokemon, pokemon_teste)

# Vamos usar a função do pacote gmodels para comparar as classificações
# do modelo aos dados de treinamento com a classificação real
CrossTable(pokemon_teste$special_group, pokemon_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c("Grupos Especiais real", "Grupos Especiais predita"))

# Capturando a saída do summary(modelo_credito)
saida_summary <- capture.output(summary(modelo_pokemon))

# Extraindo a seção "Attribute usage"
attribute_usage_lines <- saida_summary[str_detect(saida_summary, "Attribute usage") + 1:length(saida_summary)]
attribute_usage_lines <- attribute_usage_lines[str_detect(attribute_usage_lines, "^\\s+\\d+\\.\\d+%")]

# Extraindo os nomes dos atributos e suas porcentagens de uso
attribute_usage <- str_match_all(attribute_usage_lines, "\\s+(\\d+\\.\\d+)%\\s+(\\w+)")
attribute_usage <- do.call(rbind, attribute_usage)
attribute_usage <- as.data.frame(attribute_usage)
colnames(attribute_usage) <- c("Match", "Usage", "Attribute")

# Convertendo a coluna Usage para numérica
attribute_usage$Usage <- as.numeric(attribute_usage$Usage)

# Ordenando os atributos por uso (opcional, mas melhora a visualização)
attribute_usage <- attribute_usage[order(-attribute_usage$Usage), ]

# Criando o gráfico de barras para atributos mais utilizados com as porcentagens nas barras
ggplot(attribute_usage, aes(x = reorder(Attribute, Usage), y = Usage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = paste0(Usage, "%")),  # Adiciona as porcentagens
            hjust = -0.1,                     # Ajusta a posição horizontal do texto
            size = 3.5,                        # Tamanho do texto
            color = "black") +                 # Cor do texto
  coord_flip() +                               # Inverte os eixos para facilitar a leitura
  labs(
    title = "Uso dos Atributos no Modelo",
    x = "Atributos",
    y = "Porcentagem de Uso (%)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  # Centraliza o título

# Melhorando a acurácia através do Boosting
modelo_pokemon_boost10 <- C5.0(x = pokemon_treino[-20],
                               y = pokemon_treino$special_group, trials = 50)
modelo_pokemon_boost10

# Para ver cada uma das árvores geradas, use summary()
summary(modelo_pokemon_boost10)

# A taxa de erro no treinamento caiu de 13.9% para 3.8%
# Vamos agora avaliar para os dados de teste
pokemon_boost_pred10 <- predict(modelo_pokemon_boost10, pokemon_teste)
CrossTable(pokemon_teste$special_group, pokemon_boost_pred10,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c("Grupos Especiais real", "Grupos Especiais predita"))
