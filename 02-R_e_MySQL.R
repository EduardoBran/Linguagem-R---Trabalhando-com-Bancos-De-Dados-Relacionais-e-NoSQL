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



# Conexão com o Banco de Dados
?dbConnect

con = dbConnect(MySQL(), user = 'root', password = '', dbname = 'titanicDB', host = "localhost")



