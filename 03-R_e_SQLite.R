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



# Criando uma tabela e carregando com dados do dataset mtcars

# - dbWriteTable() é uma função do pacote RSQLite que permite escrever uma tabela do R em um banco de dados SQLite. Essa função recebe
#   4 argumentos: con (a conexão com o banco de dados), name (o nome da tabela no banco de dados), value (a tabela do R que será escrita
#   no banco de dados) e row.names (um argumento lógico que indica se as linhas da tabela serão ou não incluídas na escrita).

dbWriteTable(con, 'mtcars', mtcars, row.names = TRUE)


# Lista uma tabela

dbListTables(con)
dbExistsTable(con, 'mtcars')
dbExistsTable(con, 'mtcars122')
dbListFields(con, 'mtcars')      #  lista os campos ou colunas da tabela mtcars 


# Lendo o conteúdo da tabela

dbReadTable(con, 'mtcars')
View(dbReadTable(con, 'mtcars'))

View(mtcars)

# Criando apenas a definição da tabela

# - Aqui estamos indicando com o '[0, ]' que eu quero apenas a estrutra da tabela (nome de colunas) e sem os dados.

dbWriteTable(con, 'mtcars2', mtcars[0, ], row.names = TRUE)

dbListTables(con)

dbReadTable(con, 'mtcars2')
View(dbReadTable(con, 'mtcars2'))



# Executando consultas no banco de dados

# - A consulta seleciona a coluna row_names da tabela mtcars e armazena o resultado na variável rs através da função dbSendQuery.
#   Em seguida, os dados são buscados e carregados na variável dados utilizando a função fetch, que recebe como parâmetros o resultado
#   da consulta rs e o número máximo de linhas a serem recuperadas (n = -1 significa que todas as linhas serão recuperadas).

query = "select row_names from mtcars"

rs = dbSendQuery(con, query)

dados = fetch(rs, n = -1)

dados
class(dados)   # dataframe




# Executando consultas no banco de dados 

# - Aqui usamos o loop while para enquanto não tiver concluído o 'rs' , vai imprimindo os dados linha a linha
#   Neste exemplo é diferente do exemplo acima, no exemplo de cima a gente pega todo o resultado da query e grava tudo de uma vez
#   no dataframe e com isso caso a query retorne muitos dados, isso compromete a memória do computador.
#   A alternativa é usar o loop while e ir gravando linha a linha (será mais lento, mas não compromete tanta memória)

query = "select row_names from mtcars"
rs = dbSendQuery(con, query)

while (!dbHasCompleted(rs)) {
  
  dados = fetch(rs, n = 1)
  print(dados$row_names)
}




# Executando consultas no banco de dados

query = 'select disp, hp from mtcars where disp > 160'
rs = dbSendQuery(con, query)
dados = fetch(rs, n = -1)
dados




# Executando consultas no banco de dados

# - A consulta SQL acima seleciona a coluna "row_names" e a média da coluna "hp" da tabela "mtcars", agrupando por "row_names".
#   O comando "group by" é usado para agrupar os dados por valores únicos na coluna "row_names", de modo que a média de "hp" seja
#   calculada para cada grupo único de valores na coluna "row_names".

query = 'select row_names, avg(hp) from mtcars group by row_names'
rs = dbSendQuery(con, query)
dados = fetch(rs, n = -1)
dados




# Criando uma tabela a partir de um arquivo externo (iris.csv)

dbWriteTable(con, 'iris', 'iris.csv', sep = ',', header = T)

dbListTables(con)

dbReadTable(con, 'iris')



# Encerrando a conexão

dbDisconnect(con)



# Carregando mais dados no banco de dados


# Conectando o banco

drv = dbDriver("SQLite")

con = dbConnect(drv, dbname = 'exemplo.db')


# Criando uma tabela a partir de um arquivo externo (iris.csv)

dbWriteTable(con, 'indices', 'indice.csv', sep = '|', header =T)

# Excluindo a tabela

dbRemoveTable(con, 'indices')
dbListTables(con)


df <- dbReadTable(con, 'indices')
View(df)

str(df)

# fazendo um loop para verificar o tipo de cada coluna
sapply(df, class)


# plotando um histograma
hist(df$setembro)

# verificando a média de cada coluna com mês
df_mean <- unlist(lapply(df[, c(4, 5, 6, 7, 8)], mean))
df_mean

View(df_mean)



# Encerrando a conexão

dbDisconnect(con)


