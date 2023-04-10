% % Dengue
% doenca(dengue).
% sintomas(dengue, [febre_alta, dor_de_cabeca, dor_atras_dos_olhos, dores_musculares_e_nas_articulacoes, nausea, vomito, rash_cutaneo]).
sintoma(dengue, febre).
sintoma(dengue, dor_de_cabeca).
sintoma(dengue, dor_atras_dos_olhos).
sintoma(dengue, dor_muscular).
sintoma(dengue, dor_nas_articulacoes).
sintoma(dengue, nausea).
sintoma(dengue, vomito).
sintoma(dengue, rash_cutaneo).

% % Chikungunya
% doenca(chikungunya).
% sintomas(chikungunya, [febre_alta, dor_nas_articulacoes, dor_muscular, dor_de_cabeca, fadiga, rash_cutaneo]).
sintoma(chikungunya, febre).
sintoma(chikungunya, dor_nas_articulacoes).
sintoma(chikungunya, dor_muscular).
sintoma(chikungunya, dor_de_cabeca).
sintoma(chikungunya, fadiga).
sintoma(chikungunya, rash_cutaneo).

% % Zika
% doenca(zika).
% sintomas(zika, [febre_baixa, rash_cutaneo, conjuntivite, dores_musculares_e_nas_articulacoes, dor_de_cabeca]).
sintoma(zika, febre).
sintoma(zika, rash_cutaneo).
sintoma(zika, conjuntivite).
sintoma(zika, dor_muscular).
sintoma(zika, dor_nas_articulacoes).
sintoma(zika, dor_de_cabeca).

% % Doença de Chagas
% doenca(doenca_de_chagas).
% sintomas(doenca_de_chagas, [inchaco_das_palpebras_ou_ao_redor_dos_olhos, inchaco_no_abdomen, febre, mal_estar, dores_musculares, manchas_vermelhas_na_pele, inchaco_nos_membros_inferiores]).
sintoma(doenca_de_chagas, inchaco_das_palpebras_ou_ao_redor_dos_olhos).
sintoma(doenca_de_chagas, inchaco_no_abdomen).
sintoma(doenca_de_chagas, febre).
sintoma(doenca_de_chagas, mal_estar).
sintoma(doenca_de_chagas, dor_muscular).
sintoma(doenca_de_chagas, manchas_vermelhas_na_pele).
sintoma(doenca_de_chagas, inchaco_nos_membros_inferiores).

% Sinusite
sintoma(sinusite, dor_de_cabeca).
sintoma(sinusite, dor_facial).
sintoma(sinusite, congestao_nasal).
sintoma(sinusite, secrecao_nasal).
sintoma(sinusite, perda_de_olfato).

 % Bronquite aguda
sintoma(bronquite_aguda, tosse_com_muco).
sintoma(bronquite_aguda, falta_de_ar).
sintoma(bronquite_aguda, fadiga).
sintoma(bronquite_aguda, dor_no_peito).
sintoma(bronquite_aguda, febre).

 % Rinite
sintoma(rinite, espirros).
sintoma(rinite, coriza).
sintoma(rinite, congestao_nasal).
sintoma(rinite, coceira_no_nariz).
sintoma(rinite, garganta_irritada).
sintoma(rinite, tosse_seca).

 % Tuberculose
sintoma(tuberculose, tosse_prolongada).
sintoma(tuberculose, febre).
sintoma(tuberculose, suores_noturnos).
sintoma(tuberculose, fadiga).
sintoma(tuberculose, perda_de_peso_nao_intencional).

 % Pneumonia
sintoma(pneumonia, tosse).
sintoma(pneumonia, febre).
sintoma(pneumonia, calafrios).
sintoma(pneumonia, dificuldade_para_respirar).
sintoma(pneumonia, dor_no_peito).

 % Gripe
sintoma(gripe, febre).
sintoma(gripe, calafrios).
sintoma(gripe, dor_muscular).
sintoma(gripe, dor_de_garganta).
sintoma(gripe, tosse).
sintoma(gripe, fadiga).




% Probabilidades
prob_dengue(0.4).
prob_zika(0.2).
prob_chikungunya(0.3).
prob_doenca_de_chagas(0.3).
prob_sinusite(0.6).
prob_bronquite_aguda(0.5).
prob_rinite(0.7).
prob_tuberculose(0.6).
prob_pneumonia(0.3).
prob_gripe(0.8).


count_common_atoms(List1, List2, Count) :-
    findall(Atom, (member(Atom, List1), member(Atom, List2)), Atoms),
    length(Atoms, Count).

% Função que calcula a probabilidade de uma doença com base nos sintomas
probabilidade_doenca(Doenca, Sintomas, Pfinal) :-
    findall(SintomaDoenca, sintoma(Doenca, SintomaDoenca), SintomasDoenca),
    count_common_atoms(Sintomas, SintomasDoenca, NumSintomas),
    length(SintomasDoenca, NumSintomasDoenca),
    Pfinal is NumSintomas / NumSintomasDoenca.

probabilidade_dengue(Sintomas, Pfinal) :-
    prob_dengue(_),
    probabilidade_doenca(dengue, Sintomas, Pfinal).

probabilidade_zika(Sintomas, Pfinal) :-
    prob_zika(_),
    probabilidade_doenca(zika, Sintomas, Pfinal).

probabilidade_chikungunya(Sintomas, Pfinal) :-
    prob_chikungunya(_),
    probabilidade_doenca(chikungunya, Sintomas, Pfinal).

probabilidade_doenca_de_chagas(Sintomas, Pfinal) :-
    prob_doenca_de_chagas(_),
    probabilidade_doenca(doenca_de_chagas, Sintomas, Pfinal).

probabilidade_sinusite(Sintomas, Pfinal) :-
    prob_sinusite(_),
    probabilidade_doenca(sinusite, Sintomas, Pfinal).

probabilidade_bronquite_aguda(Sintomas, Pfinal) :-
    prob_bronquite_aguda(_),
    probabilidade_doenca(bronquite_aguda, Sintomas, Pfinal).

probabilidade_rinite(Sintomas, Pfinal) :-
    prob_rinite(_),
    probabilidade_doenca(rinite, Sintomas, Pfinal).

probabilidade_tuberculose(Sintomas, Pfinal) :-
    prob_tuberculose(_),
    probabilidade_doenca(tuberculose, Sintomas, Pfinal).

probabilidade_pneumonia(Sintomas, Pfinal) :-
    prob_pneumonia(_),
    probabilidade_doenca(pneumonia, Sintomas, Pfinal).

probabilidade_gripe(Sintomas, Pfinal) :-
    prob_gripe(_),
    probabilidade_doenca(gripe, Sintomas, Pfinal).



% Calculando probabilidade de cada doença
probabilidade_doencas(Prob, SintomaPaciente):-
    probabilidade_dengue(SintomaPaciente, Pdengue),
    probabilidade_zika(SintomaPaciente, Pzika),
    probabilidade_chikungunya(SintomaPaciente, Pchikungunya),
    probabilidade_doenca_de_chagas(SintomaPaciente, Pdoenca_de_chagas),
    probabilidade_sinusite(SintomaPaciente, Psinusite),
    probabilidade_bronquite_aguda(SintomaPaciente, Pbronquite_aguda),
    probabilidade_rinite(SintomaPaciente, Prinite),
    probabilidade_tuberculose(SintomaPaciente, Ptuberculose),
    probabilidade_pneumonia(SintomaPaciente, Ppneumonia),
    probabilidade_gripe(SintomaPaciente, Pgripe),
    Probabilidades = [(Pdengue, dengue), (Pzika, zika), (Pchikungunya, chikungunya), (Pdoenca_de_chagas, doenca_de_chagas), (Psinusite, sinusite), (Pbronquite_aguda, bronquite_aguda), (Prinite, rinite), (Ptuberculose, tuberculose), (Ppneumonia, pneumonia), (Pgripe, gripe)],
    sort(Probabilidades, Prob).

% Imprime as tres doenças mais prováveis
imprime_doencas(Prob) :-
    nth0(9, Prob, (P1, D1)),
    nth0(8, Prob, (P2, D2)),
    nth0(7, Prob, (P3, D3)),
    Prob1 is P1 * 100,
    Prob2 is P2 * 100,
    Prob3 is P3 * 100,
    writeln('Doencas mais provaveis:'),
    write(D1),
    write(' com probabilidade de '),
    write(Prob1),
    writeln('%'),
    write(D2),
    write(' com probabilidade de '),
    write(Prob2),
    writeln('%'),
    write(D3),
    write(' com probabilidade de '),
    write(Prob3),
    writeln('%').

% Função que mostra os sintomas que o paciente nao tem da doença mais provavel
sintomas_faltantes(Prob, SintomaPaciente) :-
    nth0(9, Prob, (P1, D1)),
    % findall(SintomaDoenca, sintoma(Doenca, SintomaDoenca), SintomasDoenca),
    findall(Sintoma, sintoma(D1, Sintoma), SintomasDoenca),
    % findall(Sintomas, sintoma(D1, Sintoma), TodosSintomas),
    subtract(SintomasDoenca, SintomaPaciente, SintomasFaltantes),
    writeln('Sintomas que voce nao tem:'),
    writeln(SintomasFaltantes).

sintomas(ListaSintomas) :- 
    findall(Sintomas, sintoma(_, Sintomas), ListaSintomas).

diagnostico(_) :-
    Todos_sintomas = [espirros, coriza, congestao_nasal, coceira_no_nariz, garganta_irritada, 
    febre, suores_noturnos, fadiga, dificuldade_para_respirar,
    perda_de_peso_nao_intencional, dor_facial, secrecao_nasal, perda_de_olfato, 
    calafrios, dor_de_garganta, tosse, tosse_com_muco, tosse_seca, tosse_prolongada,
    falta_de_ar, dor_no_peito, dor_atras_dos_olhos,
    nausea, vomito, dor_nas_articulacoes, dor_muscular, rash_cutaneo, 
    conjuntivite, dor_de_cabeca, 
    inchaco_das_palpebras_ou_ao_redor_dos_olhos, inchaco_no_abdomen, mal_estar, 
    manchas_vermelhas_na_pele, inchaco_nos_membros_inferiores],
    sintomas(_),
    imprimir_diagnostico(Todos_sintomas, [], SintomaPaciente),
    probabilidade_doencas(Prob, SintomaPaciente),
    imprime_doencas(Prob),
    nl,
    writeln('O resultado do prototipo e apenas informativo e que o paciente deve consultar um medico para obter um diagnostico correto e preciso.'),
    writeln('Deseja saber mais sobre a doença mais provavel?'),
    read(Resposta),
    ((Resposta == sim ; Resposta == s) -> 
        sintomas_faltantes(Prob, SintomaPaciente)
    ;
        true
    ).


imprimir_diagnostico([], SintomaPaciente, SintomaPaciente) :- !.
imprimir_diagnostico([Sintoma|Outros], SintomaPacienteAtual, SintomaPaciente) :-
    write('Voce tem '),
    write(Sintoma),
    write('? '),
    read(Resposta),
    ((Resposta == sim ; Resposta == s) ->
        append(SintomaPacienteAtual, [Sintoma], SintomaPacienteAtualizado),
        imprimir_diagnostico(Outros, SintomaPacienteAtualizado, SintomaPaciente)
    ;
        imprimir_diagnostico(Outros, SintomaPacienteAtual, SintomaPaciente)
    ).