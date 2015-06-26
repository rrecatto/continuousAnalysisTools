function db = replaceUnit(db,nID,sU)
if ~ident(db.data{nID},sU)
    error('can only replace identical sUs. If you wanna add extra analysis do it elsewhere');
end
db.data{nID} = sU;
end