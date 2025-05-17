---
title: "MONITORAMENTO SRAG POR COVID-19 NO ES"
subtitle: "Análise durante/pós pandemia do COVID-19 no Espírito Santo (2020-2024)"
author: "JOÃO VITOR GALIMBERTI CONTARATO"
date: "2024-12-18"
date-format: short
format:
  html:
    toc: true
    toc-depth: 2
    code-fold: false
    theme: 
      dark: darkly
    title-block-banner: true
    includes:
      in-header: header.html  
editor: visual
---

# Introdução

Este relatório apresenta uma análise das notificações de casos de SRAG (Síndrome Respiratória Aguda Grave) no estado do Espírito Santo entre os anos de 2020 e 2024 (Durante/Pós Pandemia do COVID-19). O objetivo é explorar tendências, variações e o impacto da pandemia, utilizando técnicas de visualização de dados.

Este projeto integra o trabalho final do módulo 1 da **Capacitação em Análise de Dados para Qualificação em Gestão da Saúde**, promovida pelo **Instituto Capixaba de Ensino, Pesquisa e Inovação em Saúde (ICEPi)**.

**Nota importante:** Os códigos disponibilizados neste documento não estão sendo executados devido ao grande volume e peso dos dados analisados, o que poderia comprometer o desempenho durante a renderização do relatório. Para reproduzir os resultados ou realizar testes, recomenda-se copiar o código e executá-lo diretamente em um ambiente de desenvolvimento apropriado, como o RStudio.

## Instruções para Obtenção dos Dados

Para executar este relatório, siga os passos abaixo para obter os dados necessários:

1.  Acesse o portal oficial do OpenDataSUS:

    -   [DADOS DE 2020 SRAG](https://opendatasus.saude.gov.br/dataset/srag-2020/resource/06c835a6-cf33-448a-aeb1-9dbc34065fea)
    -   [DADOS DE 2021 SRAG](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024/resource/dd91a114-47a6-4f21-bcd5-86737d4fc734)
    -   [DADOS DE 2022 SRAG](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024/resource/62803c57-0b2d-4bcf-b114-380c392fe825)
    -   [DADOS DE 2023 SRAG](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024/resource/0d78ff63-d6ca-4311-8dc8-6123cf1ca127)
    -   [DADOS DE 2024 SRAG](https://opendatasus.saude.gov.br/dataset/srag-2021-a-2024/resource/8cb52f73-0184-41d5-8a8f-87d8f415652c)

2.  Baixe o arquivo no formato CSV (formato padrão).

3.  Certifique-se de que o arquivo está no mesmo diretório do script ou ajuste o caminho no código conforme necessário.

## Carregamento dos dados

O código apresentado neste tópico ilustra o carregamento dos dados brutos:

1.  **Carregamento dos Dados:** Cada arquivo CSV correspondente aos anos de 2020 a 2024 é lido individualmente utilizando a função read.csv. Como os arquivos possuem grande volume de informações, é necessário especificar corretamente parâmetros como o tipo de separador (sep = ";") e a codificação de caracteres (fileEncoding = "ISO-8859-1"), garantindo que os dados sejam interpretados corretamente.

2.  **Filtragem por Estado:** Após a leitura, os dados são filtrados para incluir apenas notificações registradas no Espírito Santo (SG_UF_NOT == "ES"). Esse passo reduz o escopo para atender ao objetivo do relatório.

**Nota:** Devido ao tamanho dos arquivos, a execução desse código pode demandar tempo significativo.

```{r, eval = FALSE}
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
```

## Formatação dos Dados

Os dados utilizados neste relatório foram processados com base nas diretrizes do [Dicionário de Dados de SRAG Hospitalizado](https://www.saude.ba.gov.br/wp-content/uploads/2021/06/Dicionario_de_Dados_SRAG_Hospitalizado_23.03.2021.pdf) .

A filtragem e formatação foram realizadas para incluir exclusivamente as notificações referentes ao estado do Espírito Santo (ES), com foco nos casos de Síndrome Respiratória Aguda Grave (SRAG) classificados como relacionados à COVID-19.

O código apresentado neste tópico ilustra as etapas fundamentais do processamento dos dados brutos, incluindo:

1.  **Seleção de Colunas de Interesse:** Apenas colunas relevantes para a análise, como classificação final da doença (CLASSI_FIN), idade (NU_IDADE_N, TP_IDADE) e evolução do caso (EVOLUCAO), são mantidas. Isso facilita a manipulação e análise posterior.

2.  **Integração dos Dados:** Para consolidar informações de todos os anos, os dados são combinados em um único conjunto de dados utilizando a função rbind, adicionando uma coluna que identifica o ano de cada registro (ANO).

3.  **Tratamento de Valores Faltantes:** Valores ausentes (NA) nas colunas de classificação final (CLASSI_FIN) e evolução (EVOLUCAO) são substituídos por um valor padrão (9), representando registros não especificados.

4.  **Filtragem de Casos de COVID-19:** Após o processamento inicial, os dados são refinados para incluir apenas casos de SRAG confirmados como relacionados à COVID-19 (CLASSI_FIN == 5), delimitando o escopo da análise.

5.  **Conversão e Formatação da Idade em Anos:** Após a filtragem dos dados para os casos relacionados à COVID-19, é necessário uniformizar a idade dos pacientes para uma métrica comum em anos. Este passo garante que a análise seja consistente e que as idades sejam interpretadas corretamente.

```{r, eval = FALSE}
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

```

## Total de Casos de SRAG por COVID por Faixa Etária

Este código cria um gráfico de barras que mostra a distribuição total de casos de SRAG por COVID-19 agrupados por faixas etárias. A ideia é identificar quais grupos etários foram mais afetados ao longo do período analisado, fornecendo uma visão clara e informativa.

1.  **Categorização dos Dados em Faixas Etárias:** Os casos são agrupados em faixas etárias específicas para facilitar a análise demográfica. A variável IDADE_ANOS é convertida em categorias (faixas) usando a função cut. Cada faixa tem um intervalo pré-definido, como "0-1 ano", "10-20 anos", etc.

2.  **Criação do Gráfico:** Utilizando a biblioteca ggplot2, um gráfico de barras é construído para representar o número total de casos em cada faixa etária. As barras são coloridas em azul para melhorar a clareza visual, e o gráfico adota um estilo minimalista para destacar os dados.

3.  **Ajustes Estéticos:** O título e os rótulos dos eixos são adicionados para contextualizar o gráfico. O texto do eixo X (faixas etárias) é inclinado a 45 graus para evitar sobreposição e melhorar a legibilidade.

4.  **Exibição do Gráfico:** Por fim, o gráfico é renderizado e exibido, permitindo a interpretação visual dos resultados.

```{r, eval = FALSE}
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
```

## Total de Casos de SRAG por COVID por Ano

Este código cria um gráfico de barras que apresenta a distribuição total de casos de SRAG por COVID-19 ao longo dos anos. A intenção é analisar como o número de casos variou ano a ano (durante e pós pandemia), proporcionando uma visão clara da tendência temporal da doença.

1.  **Criação do Gráfico:** Utilizando a biblioteca ggplot2, um gráfico de barras é gerado, mostrando o número total de casos de SRAG por COVID-19 para cada ano. As barras são coloridas em verde escuro para proporcionar um contraste visual claro com o fundo minimalista, favorecendo a legibilidade e destacando os dados.

2.  **Ajustes Estéticos:** O título do gráfico e os rótulos dos eixos são adicionados para fornecer contexto e facilitar a compreensão dos dados. O gráfico adota um estilo minimalista para valorizar as informações sem elementos visuais desnecessários.

3.  **Exibição do Gráfico:** Ao final, o gráfico é renderizado e exibido, permitindo a interpretação visual das variações no número de casos de SRAG por COVID-19 ao longo dos anos.

```{r, eval = FALSE}
# Gráfico 2: Total de casos de SRAG por COVID por ano
grafico2 <- ggplot(dados_covid, aes(x = ANO)) +
  geom_bar(fill = "darkgreen") +
  theme_minimal() +
  labs(title = "Total de Casos de SRAG por COVID por Ano",
       x = "Ano",
       y = "Total de Casos")

print(grafico2)
```

## Evolução de casos para óbito

Este gráfico mostra a evolução dos casos de SRAG por COVID-19 que evoluíram para óbito ao longo dos anos. A análise foca especificamente nos casos cujo desfecho foi o óbito, permitindo observar como a quantidade de óbitos variou com o tempo.

1.  **Filtragem dos Casos de Óbito:** O primeiro passo é filtrar os dados para incluir apenas os casos classificados com evolução para óbito (EVOLUCAO == 2). Isso permite focar nas ocorrências mais graves da doença.

2.  **Ajuste do Rótulo da Variável de Evolução:** A variável EVOLUCAO, que originalmente pode ter múltiplos valores, é transformada para ter o rótulo "Óbito", representando o desfecho específico de interesse neste gráfico.

3.  **Criação do Gráfico:** Utilizando a biblioteca ggplot2, é criado um gráfico de barras com as ocorrências de óbito por ano. O gráfico utiliza a função geom_bar(position = "dodge"), que coloca as barras lado a lado, permitindo comparar facilmente a quantidade de óbitos a cada ano. As barras são coloridas em vermelho para destacar a gravidade dos casos.

4.  **Ajustes Estéticos:** O gráfico adota um estilo minimalista para focar nos dados, e o título, rótulos dos eixos e legenda são adicionados para garantir a clareza da informação. A cor vermelha é escolhida para representar os óbitos, e a legenda é removida para tornar o gráfico mais limpo e visualmente direto.

5.  **Exibição do Gráfico:** Ao final, o gráfico é renderizado e exibido, facilitando a visualização das variações no número de óbitos de SRAG por COVID-19 ao longo dos anos.

```{r, eval = FALSE}
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
```

# Conclusão

A análise dos dados de SRAG por COVID-19 no estado do Espírito Santo revela insights valiosos sobre o impacto da pandemia ao longo do tempo, evidenciando tendências importantes para o planejamento e aprimoramento das políticas públicas em saúde.

Inicialmente, a prevalência de casos de SRAG por COVID-19 foi alarmante, afetando diferentes faixas etárias. O gráfico que mostra a distribuição por faixa etária evidenciou como a doença atingiu diversos grupos etários, com picos de incidência em certas faixas, o que apontou a necessidade de estratégias direcionadas para cada grupo específico.

Ao observarmos a variação anual do número de casos, notamos o impacto estrondoso do surto de COVID-19 nos primeiros anos da pandemia. Os dados mostraram um aumento significativo nos casos de SRAG por COVID-19, especialmente nos primeiros momentos da pandemia, quando o sistema de saúde enfrentou grandes desafios devido ao volume de pacientes e à gravidade dos casos. No entanto, com o decorrer do tempo, políticas públicas eficazes, como campanhas de vacinação e medidas de contenção da transmissão, começaram a refletir em uma diminuição dos casos.

Em resumo, a pandemia de COVID-19 teve um impacto devastador no início, mas ao longo do tempo, com a implementação de medidas de prevenção, vacinação e o fortalecimento das políticas públicas de saúde, a situação de SRAG por COVID-19 no Espírito Santo tem mostrado uma melhora substancial. Embora a pandemia tenha exigido enormes esforços do sistema de saúde, os dados indicam uma tendência positiva, sugerindo que as ações adotadas têm contribuído para a recuperação e o fortalecimento da saúde pública no estado. Esse cenário traz esperança e reforça a importância da continuidade das medidas de saúde pública para mitigar os impactos futuros.
