# Carregando e Analisando Dados do MySQL com Linguagem R


# Configurando Diretório de Trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/6.Trabalhando-com-Bancos-de-Dados-Relacionais-e-NoSQL-em-R")
getwd()



# Instalando e carregando pacotes

# install.packages('RMySQL')
install.packages('RMySQL')
install.packages("ggplot2")
install.packages('dbplyr')    # pacote que contém drive necessário para conectar em banco de dados relacionais


library(RMySQL)
library(ggplot2)
library(dbplyr)
library(dplyr)


# Conexão com o Banco de Dados
?dbConnect

con = dbConnect(MySQL(), user = 'root', password = '', dbname = 'titanicDB', host = "localhost")

# Query

qry <- "select pclass, survived, avg(age) as media_idade from titanic where survived = 1 group by pclass, survived;"

dbGetQuery(con, qry)


# Plot (gráfico de barras)

dados <- dbGetQuery(con, qry)

ggplot(dados, aes(pclass, media_idade)) +
  geom_bar(stat = "identity")


# com pacote dbplyr

dados_dbplyr <- con3 %>%
  select(pclass, survived, age) %>%
  filter(survived == 1) %>%
  group_by(pclass, survived) %>%
  summarise(media_idade = avg(age)) %>%
  collect()



# Outra forma de fazer a conexão com o MySQL


# Conectando no MySQL com dbplyr

con2 <- src_mysql(dbname = "titanicdb", user = 'root', password = '', host = 'localhost') # a funcao src_mysql está depreciada


# forma correta atual para conectar com dbplyr

con3 <- tbl(con, "titanic")


# Coletando e agrupando os dados

# - Chama a conexao com 'con3', que já está informando qual tabela usar (titanic)
# - Concatena com 'select' para retornar algumas variáveis (colunas) e concatena com 'filter' e faz o collect para coletar os dados.
# - Isso faz selecionar todas as colunas pclass, sex, age, survived, fare onde o resultado de survived for igual a 0

dados2 <- con3 %>%
  select(pclass, sex, age, survived, fare) %>%
  filter(survived == 0) %>%
  collect()



# Manipulando os dados

# - A primeira operação é selecionar as colunas pclass, sex e survived da tabela usando a função select() do pacote dplyr.
# - A seguir, a função group_by() é usada para agrupar os dados por pclass e sex.
# - Depois, a função summarise() é usada para calcular a média da coluna survived dentro de cada grupo
#   (ou seja, dentro de cada combinação única de pclass e sex):
# - O resultado é um novo conjunto de dados que mostra a taxa média de sobrevivência para cada combinação de classe (pclass)
#   e sexo (sex) dos passageiros do Titanic.

dados3 <- con3 %>%
  select(pclass, sex, survived) %>%
  group_by(pclass, sex) %>%
  summarise(survival_ratio = avg(survived)) %>%
  collect() 


# Plot

ggplot(dados3, aes(pclass, survival_ratio, color = sex, group = sex)) +
  geom_point(size = 3) +
  geom_line()


# Sumarizando os dados

# - Utiliza a função select() do pacote dbplyr para selecionar as colunas pclass, sex, age e fare da tabela titanic do banco de dados.
# - Utiliza a função filter() do pacote dbplyr para filtrar os dados apenas para aqueles que possuem o valor de fare maior que 150.
# - Utiliza a função group_by() do pacote dbplyr para agrupar os dados pelas colunas pclass e sex.
# - Utiliza a função summarise() do pacote dbplyr para realizar uma operação de agregação nos dados. Nesse caso, é calculada a média
# - das colunas age e fare para cada combinação única de pclass e sex.

dados4 <- con3 %>% 
  select(pclass,sex,age,fare) %>%
  filter(fare > 150) %>%
  group_by(pclass,sex) %>% 
  summarise(avg_age = avg(age),
            avg_fare = avg(fare))


dados4 <- as.data.frame(dados4)



# --> Para outros bancos de dados, use RODBC





