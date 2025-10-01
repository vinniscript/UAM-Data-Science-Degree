import matplotlib.pyplot as plt
import mysql.connector

conn = mysql.connector.connect(host='localhost', database='loja', user='root', password='')

if conn.is_connected():

    conn = mysql.connector.connect(host='localhost', database='loja', user='root', password='')

    if conn.is_connected():
        cursor = conn.cursor()
        sql = ("SELECT * "
               " FROM cidade")

        sql2 = (" SELECT * "
                " FROM pedido")

        sql3 = (" SELECT * "
                " FROM pessoa ")

        sql4 = (" SELECT p.nome, c.nome "
                " FROM pessoa p "
                " INNER JOIN cidade c ON p.codCidade = c.idCidade")

        sql5 = (" SELECT c.nome, COUNT(pe.idPedido) AS pedidos"
                " FROM cidade c "
                " LEFT JOIN pessoa p ON p.codCidade = c.idCidade "
                " LEFT JOIN pedido pe ON pe.codCliente = p.idPessoa "
                " GROUP BY c.nome")

        cursor.execute(sql)
        dados = cursor.fetchall()

        print("CIDADES:")
        print(dados, "\n")

        cursor.execute(sql2)
        dados = cursor.fetchall()

        print("PEDIDOS:")
        print(dados, "\n")

        cursor.execute(sql3)
        dados = cursor.fetchall()

        print("PESSOAS:")
        print(dados, "\n")

        cursor.execute(sql4)
        dados = cursor.fetchall()

        print("PESSOAS/CIDADES:")
        print(dados, "\n")

        cursor.execute(sql5)
        dados = cursor.fetchall()

        print("EXERCÍCIO:")
        print(dados, "\n")

        cidades = []
        pedidos = []

        for linha in dados:
            cidades.append(linha[0])
            pedidos.append(linha[1])

        plt.pie(pedidos, labels=cidades, autopct="%.2f%%")
        plt.show()

# FUAQ consulte as cidades que possuem pedido, e apresente um gráfico de pizza (pie)
