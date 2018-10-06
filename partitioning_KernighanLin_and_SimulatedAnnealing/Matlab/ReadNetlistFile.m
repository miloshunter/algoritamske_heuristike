%   Funkcija ReadNetlist na osnovu .NET fajla konstruise strukture components i nets koji 
%nose dodatne informacije o komponentama i vezama izmedju njih (naziv, 
%tip komponente...) 

%Ulazni parametri:
%		fname  - string koji sadrzi putanju do .NET datoteke

%Izlazni parametri:
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

function [components, nets] = ReadNetlistFile(fname)
	
    descriptionNames = {'index', 'name', 'footprint', 'libref', '', ''};
	compCnt = 0; %inicijalizuje broj komponenti i netova
	netCnt = 0;
    E = [];
    components = [];
    nets = [];
	try
        fid = fopen(fname, 'r'); %otvara .NET datoteku
        while ~feof(fid) %i sve dok ne procita poslednji zapis
            newLine = fgetl(fid); %izvlaci novu liniju iz datoteke
            if strcmp(newLine, '[') %ako je procitan znak za uglastu zagradu radi se o definiciji komponente
                compCnt = compCnt + 1; %povecava broj komponenti
                components = [components, struct([])]; %dodaje se nova komponenta
                
				descCnt = 1; %i resetuje se broj opisnih stringova za komponentu
				components(compCnt).(descriptionNames{descCnt}) = compCnt;
				
				newLine = fgetl(fid); %cita se sledeca linija
                while ~strcmp(newLine, ']') %sve dok ne bude kraj opisa komponente
                    descCnt = descCnt + 1;
                    if ~strcmp(newLine, '') %ako je procitan string koji nije prazan
                        components(compCnt).(descriptionNames{descCnt}) = newLine; %zabelezi ga kao opis trenutne komponente
                    end
                    newLine = fgetl(fid);
                end
            elseif strcmp(newLine, '(') %ako je procitan znak za obicnu zagradu radi se o netu
				if issparse(E)
					E = sparse(size(components), size(components));
				end
				
				newLine = fgetl(fid); %cita sledecu liniju
				nets = [nets, struct([])]; %dodaje se nova komponenta
				netCnt = netCnt + 1;
				nets(netCnt).index = netCnt;
				nets(netCnt).name = newLine;
				nets(netCnt).pins = [];

                newLine = fgetl(fid);
				pinCnt = 0;
                while ~strcmp(newLine, ')') %sve dok ne bude kraj opisa neta
                    %cita iz datoteke listu komponenti koje spaja ovaj net. Posto u opisu veza
                    %postoji i informacija na koji tacno pin komponente se vezuje
                    %ovaj net, funkcija GetIndexFromName izvlaci samo
                    %informaciju koja je to komponenta i vraca njen indeks iz niza
                    %components. Ovo se smesta u matricu incidencije M.
					pinCnt = pinCnt + 1;
					nets(netCnt).pins = [nets(netCnt).pins, struct([])];
					nets(netCnt).pins(pinCnt).compName = newLine(1 : (strfind(newLine, '-') - 1));
					nets(netCnt).pins(pinCnt).pinName = newLine((strfind(newLine, '-') + 1):end);
					nets(netCnt).pins(pinCnt).compIndex = GetIndexFromName(nets(netCnt).pins(pinCnt).compName, components);
					newLine = fgetl(fid);
                end
            end
        end
    catch Me
        if (fid >= 0) 
            fclose(fid);
            error('Greska: Datoteka %s ima pogresan format!', fname);
        else
            error('Greska: Datoteka %s ne posoji!', fname);
        end
        return;
    end
    fclose(fid);
end

%Podatak name sadrzi informaciju o tome sa kojom je komponentom
%povezna dati net i na koji tacno port.
function ind = GetIndexFromName(name, components)
	ind = 0;
	%ove dve informacije su povezane znakom '-', a prvi deo informacije je
	%naziv komponente na koju je povezan net
	for i = 1 : length(components) %pretrazuje kojoj komponenti odgovara ovaj naziv
		if strcmp(components(i).name,(name))
			ind = i; %i vraca indeks te komponente
			return;
		end
	end
	return;
end