# Carregando e Analisando Dados do MySQL com Linguagem R


# Configurando Diretório de Trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/6.Trabalhando-com-Bancos-de-Dados-Relacionais-e-NoSQL-em-R")
getwd()



# Instalando e carregando pacotes

# install.packages('RMySQL')
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




# Outra forma de fazer a conexão com o MySQL


# Conectando no MySQL com dplyr

con2 <- src_mysql(dbname = "titanicdb", user = 'root', password = '', host = 'localhost')

# Coletando e agrupando os dados
# chama a conexao com 'con2', concatena com o nome da tabela que eu queroa cessar 'tbl'
# concatena com 'select' para retornar algumas variáveis (colunas) e concatena com o filtro 'filter' e faz o collect para coletar os dados
# seleciona todas as colunas pclass, sex, age, survived, fare onde o resultado de survived for igual a 0

dados2 <- con2 %>%
  tbl("titanic") %>%
  select(pclass, sex, age, survived, fare) %>%
  filter(survived == 0) %>%
  collect()


# Manipulando os dados

dados3 <- con2 %>%
  tbl("titanic") %>%
  select(pclass, sex, survived) %>%
  group_by(pclass, sex) %>%
  summarise(survival_ratio = avg(survived)) %>%
  collect() 


