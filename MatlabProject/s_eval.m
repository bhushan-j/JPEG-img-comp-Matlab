function s = s_eval(q)
if abs(q) > 50
    s=(100-abs(q))/50;
else
    s=50/abs(q);
end