p <= '1' when
    (state = S1) OR (state = S3) ELSE '0';
    
r <= '1' when
    (state = S1 and b = '0') OR (state = S2 and b = '1') OR (state = S3 and b = '1') OR (state = S4 and b = '0') ELSE '0';
    
y <= '1' when
    (state = S4 and b = '0' and a = '1') ELSE '0';    

