
function [xl,xu,fxl,fxu,xr,fxr,ea,noOfIterations] = bisectionMethod (f,Xl,Xu,es,maxIterations)
F= inline(f,'x');
xl(1)=Xl;
xu(1)=Xu;

if F(Xl)*F(Xu)>0
    xr(1)=0;ea(1)=100;noOfIterations=0;
    warning('Please check your range reason: F(Xl)*F(Xu)>0');

    return
end

 for i=1:1:maxIterations
     xr(i) = (xu(i)+xl(i))/2;
     fxr(i) = F(xr(i));
     fxl(i) = F(xl(i));
     fxu(i) = F(xu(i));
     if i >1
        ea(i) = abs((xr(i)-xr(i-1))/xr(i));
     end
     if(F(xl(i))*F(xr(i)) < 0)
         xu(i+1)=xr(i);
         xl(i+1)=xl(i);
     else
         xl(i+1)=xr(i);
         xu(i+1)= xu(i);
     end
     if(F(xl(i))*F(xr(i)) == 0)
         noOfIterations=i;
         return 
     end
     if (i>1)
          if(ea(i)<=es)
              noOfIterations=i;
              return 
          end
     end
 end
 noOfIterations=maxIterations;
end


