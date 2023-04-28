# Lab - MadReduce Para Análise de Dados com R e MongoDB


# Configurando Diretório de Trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/6.Trabalhando-com-Bancos-de-Dados-Relacionais-e-NoSQL-em-R")
getwd()



## mongodb executando



# Instalando e carregando pacotes

install.packages('devtools')
install.packages('mongolite')

library(ggplot2)
library("devtools")
library(mongolite)
library(dplyr)


# Help
?mongolite


# Cria a conexão ao MongoDB (modifica argumento 'url' para o link do atrlas na nuvem)

con <- mongo(db = "dsadb",
             collection = "airbnb",
             url = "mongodb://localhost",
             verbose = FALSE,
             options = ssl_options())

print(con)


# Visualiza os dados

dados <- con$find()
View(dados)


# Verifica o número de registros no conjunto de dados

con$count('{}')

# Busca uma amostra de dados somente com propriedades do tipo House e suas políticas de cancelamento


# buscando e exbindo o resultado de todas as linhas cujo a coluna "property_type" for igual a "House"

amostra1 <- con$find(
  query = '{ "property_type" : "House" }'
)

# buscando todas as linhas cujo a coluna "property_type" for igual a "House"
# especificando que apenas as colunas "property_type" e "cancellation_policy" devem ser exibidas no resultado.

amostra1_fields <- con$find(
  query = '{ "property_type" : "House" }',
  fields = '{ "property_type" : true, "cancellation_policy" : true }'
)

# não exibindo o campo ID

amostra2 <- con$find(
  query = '{ "property_type" : "House" }',
  fields = '{ "property_type" : true, "cancellation_policy" : true, "_id": false }'
)


# Ordenando o resultado (1 = crescente | -1 = decrescente)

amostra3 <- con$find(
  query = '{ "property_type" : "House" }',
  fields = '{ "property_type" : true, "cancellation_policy" : true, "_id": false }',
  sort = '{ "cancellation_policy" : -1 }' 
)



# Vamos agregar os dados e retornar a média de reviews (total de avaliações por tipo de propriedade)


# - O campo "_id" é um campo especial utilizado pelo MongoDB para representar o valor pelo qual os documentos são agrupados na operação
#   de agregação

amostra4 <- con$aggregate(
  '[{ "$group":{"_id": "$property_type", "count": {"$sum":1}, "average": {"$avg":"$number_of_reviews"}} }]',
  options = '{ "allowDiskUse" : true }',
)

names(amostra4) <- c("tipo_propriedade", "contagem", "media_reviews")

View(amostra4)


# Utilizando R

# - group_by(property_type): Esta é uma função do dplyr que agrupa os dados pelo campo property_type, ou seja, os dados são divididos
#   em grupos com base nos diferentes valores do campo property_type.
# - summarize(contagem = n(), media_reviews = mean(number_of_reviews)): Esta é outra função do dplyr que realiza o resumo dos dados
#   agrupados. A função n() retorna o número de observações em cada grupo, ou seja, o total de registros para cada tipo de propriedade,
#   que é atribuído à nova coluna contagem. A função mean(number_of_reviews) calcula a média dos valores do campo number_of_reviews
#   em cada grupo, ou seja, a média de reviews feitos para cada tipo de propriedade, que é atribuída à nova coluna media_reviews.
#   Uma propriedade pode ter varios reviews enquanto outra pode ter 0 review. Por isso a média.

amostra4_r <- dados %>%
  group_by(property_type) %>%
  summarize(contagem = n(), number_reviews = sum(number_of_reviews),
            media_reviews = mean(number_of_reviews), media_price = mean(price),
            media_accommodates = mean(accommodates), media_bedrooms = mean(bedrooms))

names(amostra4_r) <- c("tipo_de_propriedade", "total_propriedade", "nº_total_reviews",
                       "media_reviews_total_propriedade", "media_preco", "media_acomodacao", "media_quartos")

View(amostra4_r)



# Gerando o resultado em um gráfico de barras

ggplot(data = amostra4, aes(tipo_propriedade, contagem)) + geom_col()
ggplot(data = amostra4_r, aes(tipo_de_propriedade, total_propriedade)) + geom_col()


# Gráfico de barras comparando o total por tipo de propriedade

ggplot(data = amostra4_r, aes(tipo_de_propriedade, total_propriedade)) +
  geom_col(fill = "steelblue", width = 0.5) +
  labs(title = "Comparação de Total de Propriedade",
       x = "Tipo de Propriedade",
       y = "Total de Propriedade") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotacionar rótulos do eixo x


# Gráfico de barras comparando média de preço por tipo de propriedade

ggplot(data = amostra4_r, aes(tipo_de_propriedade, media_preco)) +
  geom_col(fill = "steelblue", width = 0.5) +
  labs(title = "Comparação de Média de Preço por Tipo de Propriedade",
       x = "Tipo de Propriedade",
       y = "Média de Preço") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotacionar rótulos do eixo x


# Gráfico de barras comparando média de quantidade de acomodação por tipo de propriedade

ggplot(data = amostra4_r, aes(tipo_de_propriedade, media_acomodacao)) +
  geom_col(fill = "steelblue", width = 0.5) +
  labs(title = "Comparação de Média de Acomodações por Tipo de Propriedade",
       x = "Tipo de Propriedade",
       y = "Média de Preço") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotacionar rótulos do eixo x



# Agrupando por grupos de property_type e cancellation_policy.

amostra4_r2 <- dados %>%
  group_by(property_type, cancellation_policy) %>%
  summarize(contagem = n(),
            number_reviews = sum(number_of_reviews),
            media_reviews = mean(number_of_reviews),
            media_price = mean(price),
            media_accommodates = mean(accommodates))


names(amostra4_r2) <- c("tipo_de_propriedade", "cancellation_policy", "total_propriedade", "nº_total_reviews",
                        "media_reviews_total_propriedade", "media_preco", "media_acomodacao")





# MapReduce - Mapeamento e Redução

# - MapReduce é um modelo de programação utilizado para processamento paralelo e distribuído de grandes volumes de dados. 
#   Foi originalmente proposto pelo Google como uma forma de lidar com a indexação de páginas da web, mas atualmente é amplamente
#   utilizado em várias aplicações, incluindo análise de dados e processamento de grandes conjuntos de dados.
# - No contexto do MongoDB ou, o MapReduce pode ser usado para executar consultas complexas em grandes conjuntos de dados, permitindo a
#   análise e a geração de relatórios de forma eficiente. O MadReduce é uma ferramenta que combina o poder do MongoDB com a linguagem de
#   programação R para permitir a análise de dados em grande escala usando o modelo MapReduce.
# - O uso do MapReduce em R pode ser especialmente útil em cenários em que os dados são muito grandes para serem processados
#   sequencialmente, ou quando se deseja aproveitar a capacidade de processamento paralelo de sistemas multi-core para acelerar o
#   processamento de dados. É uma técnica poderosa para lidar com grandes quantidades de dados de forma eficiente e escalável em
#   ambientes de análise de dados e ciência de dados.




# Contagem do número de reviews considerando todas as propriedades


resultado <- con$mapreduce(
  map = "function(){emit(Math.floor(this.number_of_reviews), 1)}", 
  reduce = "function(id, counts){return Array.sum(counts)}"
)
names(resultado) <- c("numero_reviews", "contagem")
View(resultado)

# Plot

ggplot(data = resultado, aes(numero_reviews, contagem)) + geom_col()

# Utilizando R (sem MapReduce)

resultado_r <- dados %>%
  mutate(floor_number_of_reviews = floor(number_of_reviews)) %>%
  group_by(floor_number_of_reviews) %>%
  summarize(contagem = n()) %>%
  ungroup()

names(resultado_r) <- c("numero_reviews", "contagem")

View(resultado_r)


# Utilizando R (com MapReduce)

library(dplyr)

# Função de mapeamento
map_function <- function(data) {
  data %>%
    mutate(floor_number_of_reviews = floor(number_of_reviews)) %>%
    group_by(floor_number_of_reviews) %>%
    summarize(contagem = n()) %>%
    ungroup()
}

# Função de redução
reduce_function <- function(data) {
  data %>%
    summarize(contagem = sum(contagem))
}

# Aplicar o MapReduce aos dados
resultado_mapreduce <- dados %>%
  group_by_all() %>%
  do(map_function(.)) %>%
  group_by(floor_number_of_reviews) %>%
  do(reduce_function(.))

# Converter o resultado em um data frame
resultado_mapreduce <- as.data.frame(resultado_mapreduce)

# Renomear as colunas
names(resultado_mapreduce) <- c("numero_reviews", "contagem")

# Visualizar o resultado
View(resultado_mapreduce)


# - A diferença entre os dois códigos é que o segundo código utiliza explicitamente o conceito de MapReduce, com funções de mapeamento e
#   redução separadas, enquanto o primeiro código utiliza as funções do pacote dplyr diretamente para realizar as transformações e
#   resumos dos dados em um fluxo de pipeline.
# - Em geral, você pode optar por usar o conceito de MapReduce em R quando estiver trabalhando com grandes volumes de dados e precisar
#   de uma abordagem distribuída e escalável para processamento paralelo. Por outro lado, se estiver trabalhando com conjuntos de dados
#   menores ou menos complexos, pode ser mais conveniente usar as funções do pacote dplyr diretamente, sem a necessidade de aplicar o
#   conceito de MapReduce. A escolha entre os dois enfoques depende das necessidades específicas do seu projeto e dos recursos disponíveis.




# Contagem do número de reviews por faixa de review (0 a 100, 100 a 200, 200 a 300...) considerando todas as propriedades

resultado2 <- con$mapreduce(
  map = "function(){emit(Math.floor(this.number_of_reviews/100)*100, 1)}",
  reduce = "function(id, counts){return Array.sum(counts)}"
)

names(resultado2) <- c("numero_reviews", "contagem_por_faixa")
View(resultado2)

# Plot

ggplot(data = resultado2, aes(numero_reviews, contagem_por_faixa)) + geom_col()


# Utilizando R (sem MapReduce)

resultado_r2 <- dados %>%
  mutate(floor_number_of_reviews = floor(number_of_reviews/100)*100) %>%
  group_by(floor_number_of_reviews) %>%
  summarize(contagem = n()) %>%
  ungroup()

names(resultado_r2) <- c("numero_reviews", "contagem_por_faixa")
View(resultado_r2)



# Contagem do número de quartos considerando todas as propriedades (quantas propriedadas tem x quartos)

resultado3 <- con$mapreduce(
  map = "function(){emit(Math.floor(this.bedrooms), 1)}",
  reduce = "function(id, counts){return Array.sum(counts)}"
)

names(resultado3) <- c("numero_quartos", "contagem")
View(resultado3)


# Utilizando R (sem MapReduce)

resultado_r3 <- dados %>%
  mutate(numero_quartos = floor(bedrooms)) %>%
  group_by(numero_quartos) %>%
  summarize(contagem = n()) %>%
  ungroup()

View(resultado_r3)


# Plot

ggplot(data = resultado_r3, aes(numero_quartos, contagem)) + geom_col()

ggplot(data = resultado_r3, aes(numero_quartos, contagem)) +
  geom_col(fill = "steelblue", width = 0.6) +  # Define a cor de preenchimento e largura das colunas
  labs(title = "Contagem de Quartos", x = "Número de Quartos", y = "Contagem") +  # Adiciona títulos aos eixos
  theme_minimal() +  # Aplica um tema minimalista ao gráfico
  scale_x_continuous(breaks = resultado_r3$numero_quartos, minor_breaks = NULL)  # Define os intervalos do eixo x com base nos dados reais























# Código de exemplo para medir o tempo de execução de duas operações

# Operação 1

inicio <- Sys.time()  # Registrar o tempo inicial

# Código da operação 1 aqui
resultado <- con$mapreduce(
  map = "function(){emit(Math.floor(this.number_of_reviews), 1)}", 
  reduce = "function(id, counts){return Array.sum(counts)}"
)
names(resultado) <- c("numero_reviews", "contagem")


fim <- Sys.time()  # Registrar o tempo final
tempo_execucao_op1 <- difftime(fim, inicio)  # Calcular o tempo de execução

# Operação 2

inicio <- Sys.time()  # Registrar o tempo inicial

# Código da operação 2 aqui
resultado_r <- dados %>%
  mutate(floor_number_of_reviews = floor(number_of_reviews)) %>%
  group_by(floor_number_of_reviews) %>%
  summarize(contagem = n()) %>%
  ungroup()

names(resultado_r) <- c("numero_reviews", "contagem")


fim <- Sys.time()  # Registrar o tempo final
tempo_execucao_op2 <- difftime(fim, inicio)  # Calcular o tempo de execução


# Operação 3

inicio <- Sys.time()  # Registrar o tempo inicial

# Código da operação 3 aqui
map_function <- function(data) {
  data %>%
    mutate(floor_number_of_reviews = floor(number_of_reviews)) %>%
    group_by(floor_number_of_reviews) %>%
    summarize(contagem = n()) %>%
    ungroup()
}

# Função de redução
reduce_function <- function(data) {
  data %>%
    summarize(contagem = sum(contagem))
}

# Aplicar o MapReduce aos dados
resultado_mapreduce <- dados %>%
  group_by_all() %>%
  do(map_function(.)) %>%
  group_by(floor_number_of_reviews) %>%
  do(reduce_function(.))

# Converter o resultado em um data frame
resultado_mapreduce <- as.data.frame(resultado_mapreduce)

# Renomear as colunas
names(resultado_mapreduce) <- c("numero_reviews", "contagem")

fim <- Sys.time()  # Registrar o tempo final
tempo_execucao_op3 <- difftime(fim, inicio)  # Calcular o tempo de execução



# Comparar tempos de execução
print(tempo_execucao_op1)  # Tempo de execução da operação 1
print(tempo_execucao_op2)  # Tempo de execução da operação 2
print(tempo_execucao_op3)  # Tempo de execução da operação 3




