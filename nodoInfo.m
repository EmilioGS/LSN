function [node_id, nodo_grado] = nodoInfo(nodo_aleatorio_func)
    %fprintf('<--- Consulta a nodo ---> \n');
    global nodos
    node_id = nodos(nodo_aleatorio_func).id;
    nodo_grado = nodos(nodo_aleatorio_func).grado;
end