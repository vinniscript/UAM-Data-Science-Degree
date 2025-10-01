import matplotlib.pyplot as plt
import mysql.connector

conn = mysql.connector.connect(host='localhost', database='loja', user='root', password='')

if conn.is_connected():

    cursor = conn.cursor()
    sql = (" SELECT c.nome, COUNT(p.idPessoa) AS moradores"
           " FROM cidade c "
           " RIGHT JOIN pessoa p ON c.idCidade = p.codCidade"
           "GROUP BY c.nome ")


    cursor.execute(sql)

    dados = cursor.fetchall()
    print(dados)

    cidades = []
    moradores = []

    for linha in dados:
        cidades.append(linha[0])
        moradores.append(linha[1])

        cidades[0] = 'Outra'

        plt.pie(moradores, labels=cidades, autopct="%.2f%%")
        plt.show()

# FUAQ consulte as cidades que possuem pedido, e apresente um gráfico de pizza (pie)
