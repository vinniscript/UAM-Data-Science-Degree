import networkx as nx
G = nx.Graph()

# Adicionando Vertices
G.add_node(1)
G.add_node(2)

# Visualizando os vertices
print(G.nodes())

# Adicionando Arestas
G.add_edge(1, 2)
# Total de vertices e arestas
n_vertices = G.number_of_nodes()
n_arestas = G.number_of_edges()
print(f"Total de vertices: {n_vertices}\nTotal de arestas: {n_arestas}")

G.add_edge(4, 5)
print(G.nodes())
print(G.edges())

# Desenhando
nx.draw(G, with_labels=True, node_size=1200,
        node_color="red")
