function [xi,fxi,ea,noOfIterations] = secant (f,Xi1,Xi2,es,maxIterations)
F= inline(f,'x');

xi=[Xi1 Xi2];
fxi(1) = F(xi(1));
 for i=2:1:maxIterations
     xi = [xi (xi(i)- ( F(xi(i))* (xi(i)-xi(i-1)) / (F(xi(i))-F(xi(i-1))) ) )];
     fxi(i) = F(xi(i));

     ea(i) = abs((xi(i+1)-xi(i))/xi(i+1));
     if(F(xi(i+1)) == 0)
         noOfIterations=i;
         return 
     end
      if(ea(i)<=es)
          noOfIterations=i;
          return 
      end
 end
 noOfIterations=maxIterations;

end


