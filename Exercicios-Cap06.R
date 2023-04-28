# Lista de Exercícios - Capítulo 6

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/6.Trabalhando-com-Bancos-de-Dados-Relacionais-e-NoSQL-em-R")
getwd()


# Exercicio 1 - Instale a carregue os pacotes necessários para trabalhar com SQLite e R


install.packages('RSQLite')

library(RSQLite)
library(dbplyr)





# Exercicio 2 - Crie a conexão para o arquivo mamiferos.sqlite em anexo a este script


# Criando driver SQLite

drv = dbDriver("SQLite")

# Conectado ao banco de dados (bd será criado agora e será salvo neste mesmo diretório)

mamiferos = dbConnect(drv, dbname = 'mamiferos.sqlite')





# Exercicio 3 - Qual a versão do SQLite usada no banco de dados?
# Dica: Consulte o help da função src_dbi()

?src_dbi()


# forma 1

src_dbi(mamiferos)


# forma 2

versao_sqlite <- dbGetQuery(con, "SELECT sqlite_version() as version")





# Exercicio 4 - Execute a query abaixo no banco de dados e grave em um objero em R:
# SELECT year, species_id, plot_id FROM surveys




# Exercicio 5 - Qual o tipo de objeto criado no item anterior?




# Exercicio 6 - Já carregamos a tabela abaixo para você. Selecione as colunas species_id, sex e weight com a seguinte condição:
# Condição: weight < 5
pesquisas <- tbl(mamiferos, "surveys")




# Exercicio 7 - Grave o resultado do item anterior em um objeto R. O objeto final deve ser um dataframe




# Exercicio 8 - Liste as tabelas do banco de dados carregado




# Exercicio 9 - A partir do dataframe criado no item 7, crie uma tabela no banco de dados




# Exercicio 10 - Imprima os dados da tabela criada no item anterior





