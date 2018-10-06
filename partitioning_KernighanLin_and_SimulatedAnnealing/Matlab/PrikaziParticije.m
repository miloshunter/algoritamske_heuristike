function PrikaziParticije(P1, P2, components)
	%clc;
	
	disp('Prva grupa:');
	for i = 1 : length(P1)
		fprintf('%d.\t%s\n', i, components(P1(i)).name);
    end
	disp('Druga grupa:');
	for i = 1 : length(P2)
		fprintf('%d.\t%s\n', i, components(P2(i)).name);
    end
	%disp('------------------------------------');
end