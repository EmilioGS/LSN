classdef nodo %%Clase nodo
    properties
        id;
        grado;
        %Notese que este buffer debe ser un arreglo de enteros que contenga el ID los pkts
        buffer(1,15); 
        buffer_c; %Espacios ocupados del Buffer
        backOff;
        %Atributos experimentales
        ponderacion;
    end
    methods
        function obj=nodo()
%             obj.id = id;
%             obj.grado = grado;
        end
    end
end