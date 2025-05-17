# MONITORAMENTO SRAG POR COVID-19 ESTADUAL - ANÁLISE DURANTE/PÓS PANDEMIA
# JOÃO VITOR GALIMBERTI CONTARATO

# Carregar as bibliotecas utilizadas
library(ggplot2)

# Ler e filtrar os dados de cada ano
# Como os dados são pesados demora um pouco para carregar, mas decidi fazer assim para fazer uma análise completa e bem detalhada.
dados_2020 <- read.csv("SRAG 2020.csv", sep = ";", stringsAsFactors = TRUE, fileEncoding = "ISO-8859-1")
dados_2020 <- dados_2020[dados_2020$SG_UF_NOT == "ES", ]

dados_2021 <- read.csv("SRAG 2021.csv", sep = ";", stringsAsFactors = TRUE, fileEncoding = "ISO-8859-1")
dados_2021 <- dados_2021[dados_2021$SG_UF_NOT == "ES", ]

dados_2022 <- read.csv("SRAG 2022.csv", sep = ";", stringsAsFactors = TRUE, fileEncoding = "ISO-8859-1")
dados_2022 <- dados_2022[dados_2022$SG_UF_NOT == "ES", ]

dados_2023 <- read.csv("SRAG 2023.csv", sep = ";", stringsAsFactors = TRUE, fileEncoding = "ISO-8859-1")
dados_2023 <- dados_2023[dados_2023$SG_UF_NOT == "ES", ]

dados_2024 <- read.csv("SRAG 2024.csv", sep = ";", stringsAsFactors = TRUE, fileEncoding = "ISO-8859-1")
dados_2024 <- dados_2024[dados_2024$SG_UF_NOT == "ES", ]

# Definir as colunas de interesse para análise
colunas_analise <- c("CLASSI_FIN", "NU_IDADE_N", "TP_IDADE", "EVOLUCAO")

# Adicionar a coluna do ano e combinar os dados
dados_analise <- rbind(
  cbind(ANO = 2020, dados_2020[, colunas_analise, drop = FALSE]),
  cbind(ANO = 2021, dados_2021[, colunas_analise, drop = FALSE]),
  cbind(ANO = 2022, dados_2022[, colunas_analise, drop = FALSE]),
  cbind(ANO = 2023, dados_2023[, colunas_analise, drop = FALSE]),
  cbind(ANO = 2024, dados_2024[, colunas_analise, drop = FALSE])
)

dados_analise$EVOLUCAO <- as.numeric(dados_analise$EVOLUCAO)

# Substituir os valores NA na coluna 'CLASSI_FIN' e 'EVOLUCAO' por 9
dados_analise$CLASSI_FIN[is.na(dados_analise$CLASSI_FIN)] <- 9
dados_analise$EVOLUCAO[is.na(dados_analise$EVOLUCAO)] <- 9

# Resumir os dados
summary(dados_analise)


# Filtrar apenas os casos de SRAG por COVID-19 na coluna CLASSI_FIN == 5
dados_covid <- subset(dados_analise, CLASSI_FIN == 5)

# Converter a idade para anos (TP_IDADE)
dados_covid$IDADE_ANOS <- ifelse(dados_covid$TP_IDADE == 1, 
                                 dados_covid$NU_IDADE_N / 365, # Convertendo dias para anos
                                 ifelse(dados_covid$TP_IDADE == 2, 
                                        dados_covid$NU_IDADE_N / 12, # Convertendo meses para anos
                                        dados_covid$NU_IDADE_N)) # Já está em anos

# Formatar para Idade inteira
dados_covid$IDADE_ANOS <- floor(dados_covid$IDADE_ANOS)

# Gráfico 1: Total de casos de SRAG por COVID por faixa etária
dados_covid$FAIXA_ETARIA <- cut(dados_covid$IDADE_ANOS,
                                breaks = c(-Inf, 1, 10, 20, 40, 60, 80, Inf),
                                labels = c("0-1 ano", "1-10 anos", "10-20 anos", "20-40 anos", "40-60 anos", "60-80 anos", "80+ anos"))

grafico1 <- ggplot(dados_covid, aes(x = FAIXA_ETARIA)) +
  geom_bar(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Total de Casos de SRAG por COVID por Faixa Etária",
       x = "Faixa Etária",
       y = "Total de Casos") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(grafico1)

# Gráfico 2: Total de casos de SRAG por COVID por ano
grafico2 <- ggplot(dados_covid, aes(x = ANO)) +
  geom_bar(fill = "darkgreen") +
  theme_minimal() +
  labs(title = "Total de Casos de SRAG por COVID por Ano",
       x = "Ano",
       y = "Total de Casos")

print(grafico2)

# Gráfico 3: Evolução de casos para óbito
# Filtrar apenas os óbitos (EVOLUCAO == 2)
dados_obitos <- subset(dados_covid, EVOLUCAO == 2)

# Ajustar o rótulo da variável EVOLUCAO
dados_obitos$EVOLUCAO <- factor(dados_obitos$EVOLUCAO, labels = "Óbito")

# Criar o gráfico
grafico3 <- ggplot(dados_obitos, aes(x = ANO, fill = EVOLUCAO)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  labs(title = "Evolução de Casos para Óbito por Ano",
       x = "Ano",
       y = "Total de Casos",
       fill = "Evolução") +
  scale_fill_manual(values = "red") +
  theme(legend.position = "none")

print(grafico3)
