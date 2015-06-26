function out = makerow(in)
siz= size(in);
if all(siz==0)
    out = in;
    return;
elseif ~any(siz==1)
    error('only takes in vectors');
end
if siz(1)==1
    out = in;
else
    out = in';
end
end