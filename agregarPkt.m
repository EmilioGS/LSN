function [new_buffer, new_buffer_l] = agregarPkt(buffer, buffer_l, index)
    %fprintf('<--- Agregar pkt a nodo ---> \n');
    new_buffer_l = buffer_l + 1;
    pos_inicio = find(buffer>0,1);
    pos_final = find(buffer == 0,1);
    if(isempty(pos_inicio))
        new_buffer = [index buffer(pos_final:end-1)];
    else
        new_buffer = [buffer(pos_inicio:pos_final-1) index buffer(pos_final:end-1)];
    end
end