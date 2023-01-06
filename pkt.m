classdef pkt %%Clase paquete
    properties
        %Info del propio paquete
        id;
        grado;
        %Info del nodo propietario del pkt
        nodo_id;
        nodo_grado;
        %time stamps
        tGeneracion;
        tEntradaBuffer;
        tInicioBuffer;
        tTx;
        %Atributos experimentales
        estado;
        % -1 -> Default/Perdido, -2 -> Llego al nodo Sink, -3 -> "Borrado"
        % por colision
    end
    methods
        function obj=pkt()
            
        end
    end
end