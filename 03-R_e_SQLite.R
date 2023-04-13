# Trabalhando com R e SQLite


# Configurando Diretório de Trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/6.Trabalhando-com-Bancos-de-Dados-Relacionais-e-NoSQL-em-R")
getwd()



# Instalando e carregando pacotes
install.packages('RSQLite')

library(RSQLite)


# Remover o banco SQLite, caso exista (O banco é criado no código abaixo)

system("del exemplo.db")



# Criando driver SQLite

drv = dbDriver("SQLite")


# Conectado ao banco de dados (bd será criado agora e será salvo neste mesmo diretório)

con = dbConnect(drv, dbname = 'exemplo.db')


# listando as tabelas do banco criado

dbListTables(con) 
