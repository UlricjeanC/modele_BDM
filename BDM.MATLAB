A = zeros(20,20);
for i = 1:20
    for j = 1:20
        if(rand(1)<=0.05)
            A(i,j) = 1;
        end
    end
end

max=10000;
Pp=0.05;
Pd=0.025;
Pm=0;
Cz=0.05;
k=(Pp-Pd)/Pp;
r=Pp-Pd;
mean=75;
ecart=10;

x=1:max;
v=simu(A,max,Pp,Pd,Pm);
m=moyenne(mean,Pp,Pd,Pm,max);

y=f(x,Pp,Pd);

e=erreur(m,y);
eps=erreurrelative(m,y,ecart);

plot(x,v,x,m,x,y)
legend('simulation','moyenne','prediction')
xlabel('generation')
ylabel('population')

disp('erreure absolue:')
disp(round(e))
disp('correlation:')
disp(round(eps,3))

function y=f(x,Pp,Pd)
    Cz=0.05;
    k=(Pp-Pd)/Pp;
    r=Pp-Pd;
    for t = x
        y(t)=400*(k*Cz*exp(r*t))/(k+Cz*(exp(r*t)-1));
    end
end


function A=matrice_helper(n)
    A = zeros(n,n);
    for i = 1:n
        for j = 1:n
            if(rand(1)<=0.05)
                A(i,j) = 1;
            end
        end
    end
end

function m=moyenne(mean,Pp,Pd,Pm,max)
    m=compteur(zeros(20));
    for i=1:mean
        A=matrice_helper(20);
        m=m+(1/mean)*simu(A,max,Pp,Pd,Pm);
    end
end


function x=simu(A,m,Pp,Pd,Pm)
    x=0;
    x(1)=compteur(A);
    for k = 2:m
        A=birth(A,Pp);
        A=death(A,Pd);
        A=migration(A,Pm);
        A=uni(A);
        x(k)=compteur(A);
    end 
end

function c = compteur(A)
    c=0;
    L=length(A);
    for i = 1:L
        for j = 1:L
            if A(i,j)==1
                c = c+1;
            end
        end
    end
end

function A = uni(A)
    L=length(A);
    for i = 1:L
        for j = 1:L
            if A(i,j)==2
                A(i,j)=1;
            end
        end
    end
end

function A = death(A,Pd)
    L=length(A);
    for i = 1:L
        for j = 1:L
            if and(A(i,j)==1 , rand < Pd)
                A(i,j)=0;
            end
        end
    end
end

function A = birth(A,Pb)
    L=length(A);
    for i = 1:L
        for j = 1:L
            if and(A(i,j)==1, rand < Pb)
                A=birth_helper(A,i,j);
            end
        end
    end
end

function A = migration(A,Pm)
    L=length(A);
    for i = 1:L
        for j = 1:L
            if and(A(i,j)==1, Pm > rand)
                A=migration_helper(A,i,j);
            end
        end
    end
end

function A = birth_helper(A,i,j)
    p=rand;
    L=length(A);
    if p < 0.25
        if i ~= L
            if A(i+1,j)==0
                    A(i+1,j)=2;
            end
        end
    elseif and(p > 0.25 , p < 0.5)
        if i ~= 1 
            if A(i-1,j)==0
                    A(i-1,j)=2;
            end
        end
    elseif and(p > 0.5 , p < 0.75)
        if j ~= L
            if A(i,j+1)==0
                    A(i,j+1)=2;
            end
        end
    else
        if j ~= 1
            if A(i,j-1)==0
                    A(i,j-1)=2;
            end
        end
    end
end

function A = migration_helper(A,i,j)
    p=rand;
    L=length(A);
    if p < 0.25
        if i ~= L
            if A(i+1,j)==0
                    A(i+1,j)=2;
                    A(i,j)=0;
            end
        end
    elseif and(p > 0.25 , p < 0.5)
        if i ~= 1 
            if A(i-1,j)==0
                    A(i-1,j)=2;
                    A(i,j)=0;
            end
        end
    elseif and(p > 0.5 , p < 0.75)
        if j ~= L
            if A(i,j+1)==0
                    A(i,j+1)=2;
                    A(i,j)=0;
            end
        end
    else
        if j ~= 1
            if A(i,j-1)==0
                    A(i,j-1)=2;
                    A(i,j)=0;
            end
        end
    end
end

function y = erreurrelative(v,val,e)
    y = 0;
    eps = 0;
    for i = 1:length(v)
        eps = abs(v(i)-val(i));
        if eps >= e
            y = y + (v(i)-val(i))^2;
        end
    end
    y = sqrt(y)/erreur(v,val);
    y = 1-y;
end


function y = erreur(v,val)
    y = 0;
    for i = 1:length(v)
        y = y + (v(i)-val(i))^2;
    end
    y = sqrt(y);
end
