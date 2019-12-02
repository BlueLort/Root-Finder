function [f] = read(path)
%returns the first line in the text file given in path
fid = fopen(path,'r');
f = fgetl(fid);
fclose(fid);
end