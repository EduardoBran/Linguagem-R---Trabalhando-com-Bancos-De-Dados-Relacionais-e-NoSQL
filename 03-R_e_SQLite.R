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
dbExistsTable(con, 'mtcars2')
dbListFields(con, 'mtcars')      #  lista os campos ou colunas da tabela mtcars 


# Lendo o conteúdo da tabela

dbReadTable(con, 'mtcars')
View(dbReadTable(con, 'mtcars'))



# Criando apenas a definição da tabela

# - Aqui estamos indicando com o '[0, ]' que eu quero apenas a estrutra da tabela (nome de colunas) e sem os dados.

dbWriteTable(con, 'mtcars2', mtcars[0, ], row.names = TRUE)

dbListTables(con)

dbReadTable(con, 'mtcars2')
View(dbReadTable(con, 'mtcars2'))




