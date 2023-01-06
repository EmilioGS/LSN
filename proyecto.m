close all
clear all
clc

%%% Declaración de grados y nodos %%%
global nodos;
nodos = nodo;
%numGrados = [0 1 2 3 4 5 6]; %observa que el cero es el sink
numGrados = [1 2 3 4 5 6 7]; %observa que el cero es el sink
I=7;
k=15;
numNodos = 5;
%numNodosArray = [5,10,15,20]; %Número de nodos para grado
W=16;
%WArray = [16 32 64 128 256]; %Ventana de contensión
n=0; %Variable auxiliar para creacion de los nodos
%Duraciones
DIFS = 10e-3; %Distributed Interframe Space
SIFS = 5e-3; %Short Interframe Space
RTS = 11e-3;%Ready to send
CTS = 11e-3;%Clear to send
ACK = 11e-3;%Acknowledge
DATA = 43e-3; %Sending data
Gamma = 1e-3; %Miniranura
shi = 18; %Número de ranuras de sleeping
lambda = 0.0003;
%lambdaArray = [0.0003,0.003,0.03]; %Taza de generacion de pkts/seg
%Número de ciclos
ciclos = 100000;
%Declaracion de pkts globales
global pkts;
pkts = pkt;

    %%% Generacion de nodos con valores predetermindos %%%
for i = 1:length(numGrados)
    for i2=1:numNodos
        n=n+1;
        nodos(n).id = n;
        %nodos(n).grado = i-1;%ajuste de indices para
        nodos(n).grado = i;%ajuste de indices para
        nodos(n).ponderacion = i2;
        nodos(n).buffer_c = 0;
    end
end

    %%% Espacio para resetear variables %%%
global contadorPkts_red; 
contadorPkts_red = 0; %Variable que controla
global contadorPkts_gen;
contadorPkts_gen = 0;
contadorPkts_per = 0;
contadorRetardo1 = 0;
contadorRetardo2 = 0;
idPktTx = -1;
next = 0;
%Variables auxiliares para estadisticas
pkts_perdidos = zeros(1,I);
pkts_totales = zeros(1,I);
retardo1 = zeros(1,I); 
retardo2 = zeros(1,I); 

    %%% Asignacion de tiempo %%%
lambda2 = lambda*numNodos*I;%Taza de generacion de paquetes
T = Gamma*W+ DIFS + (3*SIFS) + RTS + CTS + DATA + ACK; %tiempo de ranura
Tc = T*(shi+2); %tiempo de ciclo

global t_sim;
t_sim = 0;
ta = 0; %tiempo de arribo

    %%% Generacion primer paquete%%% 
nodo_aleatorio = randi([1,numNodos*I]); %Tomamos un nodo aleatorio
%incrementamos contadores
contadorPkts_red = contadorPkts_red + 1; %Observa que este contador cambiara conforme los pkts dejen la red
contadorPkts_gen = contadorPkts_gen + 1; 
pkts(1).id = contadorPkts_gen;
%Consultar info del nodo al pkt
[pkts(1).nodo_id, pkts(1).nodo_grado] = nodoInfo(nodo_aleatorio); %FUNCION EXTERNA
%Asignando id de pkt a nodo
[nodos(nodo_aleatorio).buffer ,nodos(nodo_aleatorio).buffer_c] = agregarPkt(nodos(nodo_aleatorio).buffer ,nodos(nodo_aleatorio).buffer_c,contadorPkts_gen);
pkts(1).tEntradaBuffer = t_sim;
pkts(1).tInicioBuffer = t_sim;
pkts(1).estado = -1; %Estado por default
%Ajuste para funcion
% contadorPkts_red = contadorPkts_red + 1; 
% contadorPkts_gen = contadorPkts_gen + 1; 

    %%% Inicio de todos los ciclos %%%
for m = 1:ciclos
    for i = (length(numGrados)):-1:1
        fprintf('Analizando por Grado %d\n', i);
        %%%%% <----- Rx -----> Inicio %%%%%
        fprintf('<--- Inicia Rx ---> \n');
        gradoSup = i + 1;
        if(gradoSup == 8)
            %Definitivamente no vamos a recibir nada
        else
          for x = 1:(contadorPkts_red)
             if(pkts(x).id == idPktTx)
               pointer = x;
             end
          end
           if(nodos(nodo_aleatorio).buffer_c ~= k)%Todavia hay espacio en el buffer
               [nodos(nodo_aleatorio).buffer ,nodos(nodo_aleatorio).buffer_c] = agregarPkt(nodos(nodo_aleatorio).buffer ,nodos(nodo_aleatorio).buffer_c,idPktTx);
               pkts(pointer).tEntradaBuffer = t_Tx;
               pkts_totales(i) = pkts_totales(i)+1;
               if(nodos(nodo_aleatorio).buffer_c == 1)
                   pkts(nodo_aleatorio).tInicioBuffer = ta; 
                   retardo1(i) = retardo1(i) + abs(pkts(next).tInicioBuffer - pkts(next).tEntradaBuffer);
                    contadorRetardo1 = contadorRetardo1 + 1;
                end
           else
               %Se borra el paquete
               %pkts(pointer) = [];
               pkts(pointer).estado = -3;
           end
        end
       
        t_sim = t_sim + T;
        %fprintf('Incrmento de tiempo en transmision%d\n',t_sim)
        while (ta<= t_sim && t_sim ~= 0)
            nodo_aleatorio = randi([1,numNodos*I]);
            contadorPkts_gen = contadorPkts_gen + 1; 
            %pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) = pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) + 1;
            pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) = pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) + 1;
            if (nodos(nodo_aleatorio).buffer_c < 15)%Se checa tamanio de buffer
                contadorPkts_red = contadorPkts_red + 1;
                generarPkt(nodo_aleatorio, ta);
                pkts(nodo_aleatorio).tEntradaBuffer = ta;
                if(nodos(nodo_aleatorio).buffer_c == 1)
                   pkts(nodo_aleatorio).tInicioBuffer = ta; 
                   retardo1(i) = retardo1(i) + abs(pkts(next).tInicioBuffer - pkts(next).tEntradaBuffer);
                    contadorRetardo1 = contadorRetardo1 + 1;
                end
            else %Caso de que no tenga espacio, rechazamos pkt
                contadorPkts_per = contadorPkts_per + 1;%Incremento pkts perdidos
                pkts_perdidos(floor((nodo_aleatorio-1)/numNodos)+1) = pkts_perdidos(floor((nodo_aleatorio-1)/numNodos)+1) + 1;%Que se utiliza para las estadisticas
            end
            ta = arribo(ta,lambda2);
        end
        %%%%% <----- Rx -----> Fin %%%%%
        
        %%%%% <----- Tx -----> Inicio %%%%%
        fprintf('<--- Inicia Tx ---> \n');
        [ganadorFunc, nodosInvolucradosFunc] = contiendas(i, W);
        if(ganadorFunc == 300)%%%%% No hay nodos que compitan %%%%% 
            %fprintf('No hay nodos que compitan\n');
        elseif(length(nodosInvolucradosFunc)>1)%%%%% Colisionan %%%%% 
            for a = 1:length(nodosInvolucradosFunc)
                %Se tienen que borar los paquetes de los nodos colisionados
                contadorPkts_per = contadorPkts_per + 1;%Incremento pkts perdidos
                %pkts_perdidos(i) = pkts_perdidos(i) + 1;%Que se utiliza para las estadisticas
                pkts_perdidos(floor((nodo_aleatorio-1)/numNodos)+1) = pkts_perdidos(floor((nodo_aleatorio-1)/numNodos)+1) + 1;
                for x = 1:(contadorPkts_red)
                  if(pkts(x).id == nodos(nodosInvolucradosFunc(a)).buffer(1))
                    pointer = x;
                  end
                  if(pkts(x).id == nodos(nodosInvolucradosFunc(a)).buffer(2))
                    next = x;
                  end
                end
                contadorPkts_red = contadorPkts_red - 1;
                %disminuimos su disponibilidad
                nodos(nodosInvolucradosFunc(a)).buffer_c = nodos(nodosInvolucradosFunc(a)).buffer_c - 1;
                %Rescribimos el buffer
                nodos(nodosInvolucradosFunc(a)).buffer = sacarPkt(nodos(nodosInvolucradosFunc(a)).buffer);
                if(nodos(nodosInvolucradosFunc(a)).buffer_c>0)
                    pkts(next).tInicioBuffer = t_sim;
                    retardo1(i) = retardo1(i) + abs(pkts(next).tInicioBuffer - pkts(next).tEntradaBuffer);
                    contadorRetardo1 = contadorRetardo1 + 1;
                end
                %Se borra el paquete
                %pkts(pointer) = [];
                pkts(pointer).estado = -3;
            end
        elseif(length(nodosInvolucradosFunc)==1)%%%%% Un nodo ganador %%%%% 
            %disminuimos su disponibilidad
            nodos(nodosInvolucradosFunc).buffer_c = nodos(nodosInvolucradosFunc).buffer_c - 1;
            for x = 1:contadorPkts_red
              if(pkts(x).id == nodos(nodosInvolucradosFunc).buffer(1))
                pointer = x;
              end
              if(pkts(x).id == nodos(nodosInvolucradosFunc).buffer(2))
                next = x;
              end
            end
            t_Tx = t_sim;
            retardo2(i) = retardo2(i) + abs(pkts(pointer).tTx - pkts(pointer).tInicioBuffer);
            contadorRetardo2 = contadorRetardo2 + 1;
            %disminuimos su disponibilidad
            nodos(nodosInvolucradosFunc).buffer_c = nodos(nodosInvolucradosFunc).buffer_c - 1;
            %Rescribimos el buffer
            [nodos(nodosInvolucradosFunc).buffer, idPktTx] = sacarPkt(nodos(nodosInvolucradosFunc).buffer);
            if(nodos(nodosInvolucradosFunc).buffer_c > 0)%si se queda un pkt en la punta
              pkts(next).tInicioBuffer = t_sim; %ya que se actualizó el buffer (libera el pkt), se graba cuando se posiciona el otro pkt en la punta
              retardo1(i) = retardo1(i) + abs(pkts(next).tInicioBuffer - pkts(next).tEntradaBuffer); %aumenta los retardo1 del grado x
              contadorRetardo1 = contadorRetardo1 + 1;
            end
            %Preguntamos si ya llego al nodo sink
            if(i>1)%si existe un grado más por transmitir
                %fprintf('Aun no ha llegado el paquete al nodo sink\n');
            else
               fprintf('El siguiente nodo es el sink\n');
               %pkts(pointer) = [];
               pkts(pointer).estado = -2;
               contadorPkts_red = contadorPkts_red - 1;
            end
        end %%%%% Fin de los casos arrojados por la funcion
        
        t_sim = t_sim + T;
        %fprintf('Incrmento de tiempo en transmision%d\n',t_sim)
        while (ta<= t_sim && t_sim ~= 0)
            nodo_aleatorio = randi([1,numNodos*I]);
            contadorPkts_gen = contadorPkts_gen + 1; 
            %pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) = pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) + 1;
            pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) = pkts_totales(floor((nodo_aleatorio-1)/numNodos)+1) + 1;
            if (nodos(nodo_aleatorio).buffer_c < 15)%Se checa tamanio de buffer
                contadorPkts_red = contadorPkts_red + 1;
                generarPkt(nodo_aleatorio, ta);
                pkts(nodo_aleatorio).tEntradaBuffer = ta;
                if(nodos(nodo_aleatorio).buffer_c == 1)
                   pkts(nodo_aleatorio).tInicioBuffer = ta; 
                   retardo1(i) = retardo1(i) + abs(pkts(next).tInicioBuffer - pkts(next).tEntradaBuffer);
                    contadorRetardo1 = contadorRetardo1 + 1;
                end
            else %Caso de que no tenga espacio, rechazamos pkt
                contadorPkts_per = contadorPkts_per + 1;%Incremento pkts perdidos
                pkts_perdidos(floor((nodo_aleatorio-1)/numNodos)+1) = pkts_perdidos(floor((nodo_aleatorio-1)/numNodos)+1) + 1;%Que se utiliza para las estadisticas
            end
            ta = arribo(ta,lambda2);
        end
        %%%%% <----- Tx -----> Fin %%%%%
    end
end

%%% Recorrer todos los grados con su contienda (borrador) %%%
% for recorrer = (length(numGrados)):-1:1
%     [ganadorFunc, nodosInvolucradosFunc] = contiendas(recorrer, W);
% end