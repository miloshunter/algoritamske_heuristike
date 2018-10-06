%Funkcija KerninghanLin

%Ulazni parametri:
%
%		components - niz struktura (structure array), gde svaka struktura 
%				opisuje po jednu komponentu sa sheme i sadrzi sve podatke 
%				o komponenti koji su prosledjeni od strane Protela. Npr: 
%						components(1) =
%									 index: 1
%									  name: 'a'
%									libref: 'NAND2'
%		nets - niz struktura (structure array), gde svaka struktura opisuje
%				po jednu vezu (net) sa sheme i sadrzi sve podatke o njoj
%				koji su prosledjeni od strane Protela. Npr:
%						nets(1) = 
%									 index: 1
%									  name: 'N1'
%				Osim toga, svaka struktura u nets nizu sadrzi niz struktura
%				pod nazivom "pins". Ove strukture cuvaju informacije o tome
%				na koji pin je tacno povezan odgovarajuci net. Npr:
%						pins =
%								compName - naziv komponente kojoj pripada
%											pin
%								pinName - naziv pina
%								compIndex - redni broj komponente

%Izlazni parametri:
%
%		P1 - niz indeksa komponenti koje pripadaju prvoj particiji
%
%		P2 - niz indeksa komponenti koje pripadaju prvoj particiji
%
%		cutWeight - merilo povezanosti komponenti u razlicitim particijama
%				u odnosu na povezanost izmedju komponenti u istim particijama
%
%		cutSize - broj veza izmedju komponenti u razlicitim particijama


function [P1, P2] = KernighanLin(components, nets, weight_matrix)

	%[n c] = size(E); %izvlaci ukupan broj komponenti(c) i broj ukupan broj netova (n) iz matrice E

	c = length(components) - 2; % MILOS: zbog zakljucane 2 komponente
	n = length(nets);

	G = weight_matrix; %matrica tezina, simetricna matrica u koju ce biti smesteni brojevi G(i,j) 
	%koji predstavljaju meru, koliko komponente Ci i Cj teze da budu u istoj particiji
	
	%svaki net doprinosi tezini izmedju dve komponenti koje povezuje za 1 / (ukupan_broj_komponenti_koje_povezuje_net - 1)
	%sto odrazava to da ako su neke dve komponente povezane netom koji povezuje
	%samo te dve komponente (ili mali broj komponenti), onda su te dve komponente vise
	%povezane nego ako su povezane netom koji povezuje velik broj komponenti

	
	%***************************************
	%*    KOD ZA KONSTRUKCIJU MATRICE G    *
	%***************************************
	
	
	%inicijalno pretpostavljamo neku podelu, odnosno pravimo nasumicnu
	%permutaciju komponenti i uzimamo prvu polovinu za prvu podelu, a drugu
	%polovinu za drugu
	%A = randperm(c);
	P1_all = [1 3 5 7 9];
	P2_all = [2 4 6 8 10];
    cutsize = 0;
    for i = 1 : length(P1_all)
        for j = 1 : length(P2_all)
            cutsize = cutsize + G(P1_all(i), P2_all(j));
        end
    end
    disp("Pocetni cutsize");
    disp(cutsize);
    PrikaziParticije(P1_all, P2_all, components);

    P1 = [3 5 7 9];
	P2 = [4 6 8 10];

	maxTotalGain = 1; %pamti koliko smo kvalitativno uznapredovali u svakoj iteraciji, odnosno koliko je podela
						%u ovoj iteraciji bolja nego u prethodnoj

	%while (maxTotalGain > 1e-10) %pokusavamo da popravimo podelu sve dok imamo neki napredak (uzeto je 10^-10 zbog masinske preciznosti)

		%nizovi koji cuvaju informacije o mogucim zamenama komponenti iz jedne
		%particije u drugu
		maxGain = ones(floor(c/2), 1) * (-inf); %koliki se napredak dobija svakom zamenom, na pocetku se postavlja na najmanju mogucu vrednost = -beskonacno
										%maxGain(i) je jednak napretku koji se dobija i-tom zamenom
		swapP1 = zeros(floor(c/2), 1); %dva niza koji pamte redne brojeve komponenti za koje se predlaze zamena
		swapP2 = zeros(floor(c/2), 1); %swapP1(i) je jednak rednom broju komponente koja se iz P1 prebacuje u P2 u i-toj zameni
								%swapP2(i) je jednak rednom broju komponente koja se iz P2 prebacuje u P1 u i-toj zameni

		Dp1 = zeros(1, length(P1)); %parametri koji izrazava podobnost da se neka komponenta prebaci iz sopstvene particije u drugu particiju
		Dp2 = zeros(1, length(P2)); %Dp1 cuva podobnost prebacivanja za elemente particije P1, Dp2 za elemente particije P2
		swap = 0; %koliko zamena je dosad napravljeno

		%alternativno Dp1 = sum(G(P1,P2)') - sum(G(P1,P1)'), ili sum(G(P1,P2),2) - sum(G(P1,P1),2)
		for i = 1 : length(P1)  %racunaju se elementi niza Dp1
			for j = 1 : length(P1_all) %prolazi kroz sve elmente particije P1
				Dp1(i) = Dp1(i) - G(P1(i),P1_all(j)); %tezina koja povezuje komponentu sa komponente iz iste particije, smanjuje podobnost prebacivanja
			end
			for j = 1 : length(P2_all) %prolazi kroz sve elemente particije P2
				Dp1(i) = Dp1(i) + G(P1(i),P2_all(j)); %tezina koja povezuje komponentu sa komponentama iz suprotne particije, povecava podobnost prebacivanja
			end
		end

		for i = 1 : length(P2) %na isti nacin se racunaju elementi niza Dp2
			for j = 1 : length(P2_all)
				Dp2(i) = Dp2(i) - G(P2(i),P2_all(j));
			end
			for j = 1 : length(P1_all)
				Dp2(i) = Dp2(i) + G(P2(i),P1_all(j));
			end
		end

		while(swap < floor(c/2)) %radi sve dok se ne naprave zamene za svaki element
			swap = swap + 1; %povecaj brojac zamena

			for i = 1 : length(P1) %prolazimo kroz sve moguce parove komponenti gde je prva komponenta iz P1 a druga iz P2
				for j = 1 : length(P2)
					gain = Dp1(i) + Dp2(j) - 2 * G(P1(i), P2(j)); %racuna koliki napredak bi se ostvario zamenom ove dve komponente
					if (gain > maxGain(swap)) %da li je to najveci napredak pronadjen u ovoj iteraciji
						maxGain(swap) = gain; %ako jeste, zapamti koliki je napredak i koje se komponente menjaju
						swapIndexP1 = i;
						swapIndexP2 = j;
					end
				end
			end

			%kada se proslo kroz sve parove, pronadjena je zamena sa maksimalnim napretkom
			swapP1(swap) = P1(swapIndexP1); %i ona se belezi u niz zamena
			swapP2(swap) = P2(swapIndexP2);

			%izbacuje dve komponente koje ucestvuju u zameni iz particija P1 i P2, i nizova 
			%parametara podobnosti prebacivanja Dp1 i Dp2
            
            P1_all_swap = find(P1_all == P1(swapIndexP1));
            tmp = P1_all(P1_all_swap);
            P2_all_swap = find(P2_all == P2(swapIndexP2));
			P1_all(P1_all_swap) = P2_all(P2_all_swap);
            P2_all(P2_all_swap) = tmp;
            
            cutsize = 0;
            for i = 1 : length(P1_all)
                for j = 1 : length(P2_all)
                    cutsize = cutsize + G(P1_all(i), P2_all(j));
                end
            end
            fprintf('Max gain: %f\n', maxGain(swap));
            fprintf('Zameniti %s i %s \n', components(swapP1(swap)).name, components(swapP2(swap)).name);
            disp('------------------------------------');
            
            fprintf('Cutsize: %f\n', cutsize);
            PrikaziParticije(P1_all, P2_all, components);
            
			P1 = [P1(1 : (swapIndexP1 - 1))		P1((swapIndexP1 + 1) : end)]; 
			P2 = [P2(1 : (swapIndexP2 - 1))		P2((swapIndexP2 + 1) : end)];
            
			Dp1 = [Dp1(1 : (swapIndexP1 - 1))		Dp1((swapIndexP1 + 1) : end)];
			Dp2 = [Dp2(1 : (swapIndexP2 - 1))		Dp2((swapIndexP2 + 1) : end)];

			%preracunava koliki bi parametri podobnosti prebacivanja ostalih komponenti bili,
			%kada bi ove dve komponente, koje ucestvuju u zameni, zamenile mesta u particijama
			for i = 1 : length(P1)
				Dp1(i) = Dp1(i) + 2 * G(P1(i), swapP1(swap)) - 2 * G(P1(i), swapP2(swap));
			end

			for i = 1 : length(P2)
				Dp2(i) = Dp2(i) + 2 * G(P2(i), swapP2(swap)) - 2 * G(P2(i), swapP1(swap));
			end

			%nastavlja sa sledecom iteracijom, gde pronalazi sledece dve
			%komponente
			%cijom bi se zamenom dobio maksimalni napredak
        end

		%kada su pronadjeni svi moguci parovi komponenti za zamenu, trazi se koliko
		%zamena treba izvrsiti da bi se ukupno napravio maksimalan napredak.
		%Zamene se izvrsavaju redom, od prve pronadjene ka poslednjoj.
		maxTotalGain = -inf;
		maxSwaps = 0;
		totalGain = 0;
		for i = 1 : floor(c/2) %prolazimo redom kroz sve zamene
			totalGain = totalGain + maxGain(i); %dodajemo napredak trenutno zamene, ukupnom napretku
			if (maxTotalGain < totalGain) %da li je ovo maksimalni dosadasnji ukupan napredak?
				maxTotalGain = totalGain; %ako jeste, zapamti koliko zamena treba izvrsiti da bi se on postigao
				maxSwaps = i;
			end
		end

		%kada smo pronasli odgovor na pitanje koliko zamena treba izvrsiti,
		%vrsimo preraspodelu komponenti, tako sto izvrsavamo ovaj broj zamena.
		for i = 1 : floor(c/2)
			if ((i > maxSwaps) || (maxTotalGain < 1e-10)) %ako ne treba da se vrsi vise zamena, vracaju se stari elementi u niz
				P1 = [P1	swapP1(i)];
				P2 = [P2	swapP2(i)];
			else
				P1 = [P1	swapP2(i)];  %vrse se zamene
				P2 = [P2	swapP1(i)];
			end
		end

		%ako smo napravili napredak (maxTotalGain > 0), idemo u jos jednu
		%iteraciju u nadi da cemo jos popraviti rezultat, ako nismo, smatramo
		%da smo dostigli optimum i zavrsavamo algoritam
	%end
	
	%Na cutweight povecavaju tezine izmedju komponenti u razlicitim particijama
	% a negativno izmedju komponenti u istim particijama
		
	%cutWeight = ...

	%broj veza izmedju komponenti izmedju dve particije
	
	%cutSize = ...
end