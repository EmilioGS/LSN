function [new_buffer, pkt_id] = sacarPkt(buffer)
    pkt_id = buffer(1);
    aux = buffer(2:end);
    new_buffer = [aux 0];
end