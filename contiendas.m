function [ganador, nodosInvolucrados] = contiendas(grado, W)

gradoReal = grado; %A lo mejor se usa mas adelante
grado = grado - 1;
fprintf('<--- Contienda en Grado: %d ---> \n', grado);
%Estableciendo limites
gradoAux5 = (grado*5)+1;
gradoFin5 = gradoAux5+4;
gradoAux10 = grado*10;
gradoFin10 = gradoAux10+10;
gradoAux15 = grado*15;
gradoFin15 = gradoAux15+15;
gradoAux20 = grado*20;
gradoFin20 = gradoAux20+20;
%Variables auxiliares para las ranuras de tiempo
vectorGrado = 0;
vectorGrado_i = 0;
global nodos

%Deteccion de numeros de Nodos
if( length(nodos)==35 ) %Entramos al caso de 5 Nodos por grado
    if(grado == 0)
        for aux=1:5
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    else
        for aux = (gradoAux5):gradoFin5
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else 
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    end
    gradoAux=gradoAux5-1;
elseif(length(nodos)==70) %Entramos al caso de 10 Nodos por grado
    if(grado == 0)
        for aux=1:10
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else 
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    else
        for aux = (gradoAux10+1):gradoFin10
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else 
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    end
    gradoAux=gradoAux10;
elseif(length(nodos)==105) %Entramos al caso de 15 Nodos por grado
    if(grado == 0)
        for aux=1:15
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else 
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    else
        for aux = (gradoAux15+1):gradoFin15
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else 
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    end
    gradoAux=gradoAux15;
elseif(length(nodos)==140) %Entramos al caso de 20 Nodos por grado
    if(grado == 0)
        for aux=1:20
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else 
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    else
        for aux = (gradoAux20+1):gradoFin20
            vectorGrado_i = vectorGrado_i + 1;
            if( ~isempty(nodos(aux).buffer))
                nodos(aux).backOff = ceil((W-1)*rand);
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            else 
                nodos(aux).backOff = 300; %Valor por default de los nodos que no van a contender
                vectorGrado(vectorGrado_i) = nodos(aux).backOff;
            end
        end
    end
    gradoAux=gradoAux20;
end

%Visualización de vector auxiliar ordenado
vectorGrado
%length(vectorGrado) %Debug para ver que se adapte a diferentes tamanios
ganador = min(vectorGrado)

n = 0;
for i=1:length(vectorGrado)
    if(ganador == vectorGrado(i))
        n = n + 1;
        nodosInvolucrados(n) = gradoAux + i;
    end
end

fprintf('n: %d (numeros de backOff iguales)\n', n);

if(n == 1)
    fprintf('Tx Successfull Node: %d\n', nodosInvolucrados);
else
    fprintf('Tx Failure Node: %d\n', nodosInvolucrados);
end

end

