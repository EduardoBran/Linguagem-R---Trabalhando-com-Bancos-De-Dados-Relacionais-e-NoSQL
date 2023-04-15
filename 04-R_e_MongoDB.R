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


# Help
?mongolite


# Cria a conexão ao MongoDB (modifica argumento 'url' para o link do atrlas na nuvem)

con <- mongo(db = "dsadb",
             collection = "airbnb",
             url = "mongodb://localhost",
             verbose = FALSE,
             options = ssl_options())

print(con)









