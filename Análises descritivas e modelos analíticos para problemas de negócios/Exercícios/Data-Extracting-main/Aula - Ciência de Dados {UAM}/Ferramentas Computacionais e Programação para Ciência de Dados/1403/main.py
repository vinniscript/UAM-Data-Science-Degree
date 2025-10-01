import mysql.connector

conn = mysql.connector.connect(host='localhost', database='loja', user='root', password='')

if conn.is_connected():

    cursor = conn.cursor()
    # cursor.execute(" SELECT * FROM produto ")
    # cursor.execute(" DESCRIBE produto ")
    # cursor.execute( "DESCRIBE CATEGORIA" )
    #sql = "SELECT p.nome, p.preco, c.nome FROM produto p INNER JOIN categoria c ON p.codCategoria = c.idCategoria"
    #sql2 = "SELECT p.nome, p.altura, c.nome FROM pessoa p INNER JOIN cidade c ON p.codCidade = c.idCidade ORDER BY p.altura"

    sql = " SELECT v.idPedido, DATE_FORMAT( v.horario, '%d/%m/%Y %H:%i:%s' ) AS hora, p.nome, v.endereco, c.nome AS município"
    sql += " FROM pedido v "
    sql += " LEFT JOIN pessoa p ON v.codCliente = p.idPessoa"
    sql += " LEFT JOIN cidade c ON p.codCidade = c.idCidade "



    # cursor.execute( sql )
    cursor.execute(sql)

    result = cursor.fetchall()

    print("---------------------")

    for prd in result:
        print(prd)

    cursor.close()
    conn.close()