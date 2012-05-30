inp = fopen('sensors.bin','r', 'b');
MAX_SEN=15; %15 is assumed maximum number of sensor types
MAX_DAT=9; %9 is assumed maximum data length
out=zeros(MAX_SEN,1);    
data=zeros(MAX_DAT,1); 
while (~feof(inp))
    typ = fread(inp, 1, 'int32',0);
    if (isempty(typ))   %incosistent foef. no more data
        break;
    end
    
    sysTime = fread(inp, 1, 'int64',0);
    evTime = fread(inp, 1, 'int64',0);
    len = fread(inp, 1, 'int32',0);
    for i=1:len
        data(i)=fread(inp, 1, 'float',0);
    end
    
    %Record the data as ascii
    if (out(typ)==0)
        %Create an output file
        out(typ)=fopen(['sensor' num2str(typ) '.txt'],'w');
    end
    
    fprintf(out(typ), '%ld %ld ', sysTime, evTime);
    fprintf(out(typ), ' %.16f ', data(1:len));
    fprintf(out(typ), '\n');
end

fclose(inp);
for i=1:MAX_SEN
    if (out(i)~=0)
       fclose(out(i));
    end
end