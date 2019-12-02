function [xr,fxr,ea,noOfIterations] = fixedPointMethod(f,g,xl,xu,es,maxIterations)
%G(str2sym('x'))=str2sym(g);
F= inline(f,'x');
G=inline(g,'x');
x(1)=(xl+xu/2);
for i=1:1:maxIterations
    xr(i)=G(x(i));
    fxr(i) = F(xr(i));
    ea(i)=abs((xr(i)-x(i))/xr(i));
    x(i+1)=xr(i);
    if(F(xr(i)) == 0)
        noOfIterations=i;
     return 
     end
    if(ea(i)<=es)
        noOfIterations=i;
        return
    end

end
noOfIterations=i;
end

