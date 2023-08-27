reencarno(wan,kyoshi).
reencarno(kyoshi,roku).
reencarno(roku,aang).
reencarno(aang,korra).

% PUNTO 1

% A)
vidasPasadas(AvatarAnterior,AvatarSiguiente):-
    reencarno(AvatarAnterior,AvatarSiguiente).

vidasPasadas(AvatarAnterior,AvatarSiguiente):-
    reencarno(AvatarAnterior,AvatarDelMedio),
    vidasPasadas(AvatarDelMedio,AvatarSiguiente).

% B)
avatar(wan).
avatar(Avatar):-
    vidasPasadas(wan,Avatar).

% C)
avatarActual(Avatar):-
    avatar(Avatar),
    not((reencarno(Avatar,Otro), Avatar \= Otro)).


% PUNTO 2

% maestro(NombreMaestro,ElementoQueDomina).
maestro(katara,elemento(agua)).
maestro(toph,elemento(tierra)).
maestro(zuko,elemento(fuego)).
maestro(tenzin,elemento(aire)).

elemento(aire).
elemento(fuego).
elemento(tierra).
elemento(agua).

controla(Persona,Elemento):-
    maestro(Persona,elemento(Elemento)).

controla(Persona,Elemento):-
    avatar(Persona),
    elemento(Elemento).

% PUNTO 3

tecnicaBasica(tornado,elemento(aire)).
tecnicaBasica(lanzarLlamas,elemento(fuego)).
tecnicaBasica(congelar,elemento(agua)).

tecnicaAvanzada(sangreControl,elemento(agua)).
tecnicaAvanzada(metalControl,elemento(tierra)).

tecnicaCombinada(fundicion,metalControl).
tecnicaCombinada(fundicion,lanzarLlamas).

tecnicaCombinada(regularTemperatura,sangreControl).
tecnicaCombinada(regularTemperatura,congelar).
tecnicaCombinada(regularTemperatura,lanzarLlamas).

% fueEntrenado(Alumno,Maestro).
fueEntrenado(aang,katara).
fueEntrenado(toph,katara).
fueEntrenado(korra,toph).

puedeUtilizar(Tecnica,Persona):-
    tecnicaBasica(Tecnica,elemento(Elemento)),
    controla(Persona,Elemento).

puedeUtilizar(Tecnica,Persona):-
    tecnicaAvanzada(Tecnica,elemento(Elemento)),
    controla(Persona,Elemento),
    fueEntrenado(Persona,Maestro),
    puedeUtilizar(Tecnica,Maestro).

puedeUtilizar(sangreControl,katara).
puedeUtilizar(metalControl,toph).

puedeUtilizar(Tecnica,Persona):-
    controla(Persona,_),
    tecnicaCombinada(Tecnica,_),
    forall(tecnicaCombinada(Tecnica,Componente), puedeUtilizar(Componente,Persona)).

puedeUtilizar(Tecnica,Avatar):-
    vidasPasadas(Anterior,Avatar),
    puedeUtilizar(Tecnica,Anterior).


% PUNTO 4

% hazania(Nombre,TecnicaNecesaria).
hazania(escaparPrision,sangreControl).
hazania(capturarBaSingSe,metalControl).
hazania(capturarBaSingSe,tornado).
hazania(capturarBaSingSe,lanzarLlamas).

sonCapacesDeLograr(Hazania,Grupo):-
    hazania(Hazania,_),
    forall(hazania(Hazania,Tecnica), (puedeUtilizar(Tecnica,Persona),member(Persona,Grupo))).


% PUNTO 5

% A)
tecnicaNueva(Avatar,Tecnica):-
    puedeUtilizar(Tecnica,Avatar),
    forall(vidasPasadas(Anterior,Avatar), not(puedeUtilizar(Tecnica,Anterior))).

% B)
masProlifico(Avatar):-
    tecnicasNuevas(Avatar,MasTecnicasNuevas),
    length(MasTecnicasNuevas,CantidadMayor),
    forall((tecnicasNuevas(_,TecnicasNuevas),length(TecnicasNuevas,Cantidad)), CantidadMayor >= Cantidad).

tecnicasNuevas(Avatar,TecnicasNuevas):-
    avatar(Avatar),
    findall(Tecnica, distinct(tecnicaNueva(Avatar,Tecnica)), TecnicasNuevas).
