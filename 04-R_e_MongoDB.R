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




