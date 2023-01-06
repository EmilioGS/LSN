function taFunc = arribo(t,lambda)
    u = 1e6*rand()/1e6;
    neuevoT = -(1/lambda)*log(1-u);
    taFunc = t + neuevoT;
end