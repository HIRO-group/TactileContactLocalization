function [gm] = read_stl(fileName)
    gm = fegeometry(fileName);
    pdegplot(gm)
    
end

