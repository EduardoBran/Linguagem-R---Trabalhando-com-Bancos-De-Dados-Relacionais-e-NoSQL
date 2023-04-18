# Lab - MadReduce Para Análise de Dados com R e MongoDB


# Configurando Diretório de Trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/6.Trabalhando-com-Bancos-de-Dados-Relacionais-e-NoSQL-em-R")
getwd()



## mongodb executando



# - MapReduce é um modelo de programação utilizado para processamento paralelo e distribuído de grandes volumes de dados. Foi
#   originalmente proposto pelo Google como uma forma de lidar com a indexação de páginas da web, mas atualmente é amplamente utilizado
#   em várias aplicações, incluindo análise de dados e processamento de grandes conjuntos de dados.
# - No contexto do MongoDB, o MapReduce pode ser usado para executar consultas complexas em grandes conjuntos de dados, permitindo a
#   análise e a geração de relatórios de forma eficiente. O MadReduce é uma ferramenta que combina o poder do MongoDB com a linguagem de
#   programação R para permitir a análise de dados em grande escala usando o modelo MapReduce.



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
            media_reviews = mean(number_of_reviews), media_price = mean(price), media_accommodates = mean(accommodates))

names(amostra4_r) <- c("tipo_de_propriedade", "total_propriedade", "nº_total_reviews",
                       "media_reviews_total_propriedade", "media_preco", "media_acomodacao")

View(amostra4_r)



# Gerando o resultado em um gráfico de barras

ggplot(data = amostra4, aes(tipo_propriedade, contagem)) + geom_col()
ggplot(data = amostra4_r, aes(tipo_de_propriedade, total_propriedade)) + geom_col()


# Criar gráfico de barras comparando média de preço por tipo de propriedade

ggplot(data = amostra4_r, aes(tipo_de_propriedade, total_propriedade)) +
  geom_col(fill = "steelblue", width = 0.5) +
  labs(title = "Comparação de Total de Propriedade",
       x = "Tipo de Propriedade",
       y = "Média de Preço") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotacionar rótulos do eixo x


ggplot(data = amostra4_r, aes(tipo_de_propriedade, media_preco)) +
  geom_col(fill = "steelblue", width = 0.5) +
  labs(title = "Comparação de Média de Preço por Tipo de Propriedade",
       x = "Tipo de Propriedade",
       y = "Média de Preço") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotacionar rótulos do eixo x


ggplot(data = amostra4_r, aes(tipo_de_propriedade, media_acomodacao)) +
  geom_col(fill = "steelblue", width = 0.5) +
  labs(title = "Comparação de Média de Acomodações por Tipo de Propriedade",
       x = "Tipo de Propriedade",
       y = "Média de Preço") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotacionar rótulos do eixo x



# aqui estamos agrupando por grupo de property_type e cancellation_policy.

amostra4_r2 <- dados %>%
  group_by(property_type, cancellation_policy) %>%
  summarize(contagem = n(),
            number_reviews = sum(number_of_reviews),
            media_reviews = mean(number_of_reviews),
            media_price = mean(price),
            media_accommodates = mean(accommodates))


names(amostra4_r2) <- c("tipo_de_propriedade", "cancellation_policy", "total_propriedade", "nº_total_reviews",
                        "media_reviews_total_propriedade", "media_preco", "media_acomodacao")








