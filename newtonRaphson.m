function [xi,fxi,ea,noOfIterations] = newtonRaphson (f,Xi,es,maxIterations)
F= inline(f,'x');
Fd = diff(sym(f),1)%diff(sym(f),8)
Fd = inline(Fd,'x')

xi(1)=Xi;

 for i=1:1:maxIterations
     xi = [xi (xi(i)- (F(xi(i))/ Fd(xi(i)) ) )];
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


