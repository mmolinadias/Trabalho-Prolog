% Felipe Chatalov    118992
% Matheus Molina     120118

% Materia: Paradigma de programacao logica e funcional - UEM

:- consult('diagnosticar.pl').
:- dynamic paciente/4.

header:-

    write('______________________________________________________________'), nl,
    write('|              SISTEMA DE DIAGNOSTICO DE DOENCAS             |'), nl,
    write('|       Digite:                                              |'), nl,
    write('|  [1] Comecar diagnostico.                                  |'), nl,
    write('|  [2] Cadastrar novo paciente.                              |'), nl,
    write('|  [3] Listar todos pacientes.                               |'), nl,
    write('|  [4] Buscar o registro de um paciente.                     |'), nl,
    write('|  [5] Atualizar o registro de um paciente.                  |'), nl,
    write('|  [6] Excluir o registro de um paciente.                    |'), nl,
    write('|  [7] Sair do sistema.                                      |'), nl,
    write('|____________________________________________________________|'), nl,

    read(Escolha),

    (Escolha = 1 -> diagnostico, header ; true),
    (Escolha = 2 -> cadastrar_paciente, header ; true),
    (Escolha = 3 -> listar_pacientes, header ; true),
    (Escolha = 4 -> busca_paciente, header ; true),
    (Escolha = 5 -> atualiza_paciente, header ; true),
    (Escolha = 6 -> exclui_paciente, header ; true),
    (Escolha = 7 -> write('Saindo do sistema') ; true).


% realiza o diagnostico
diagnostico:-
    diagnostico(Sintoma).

% cadastro de novo paciente

cadastrar_paciente:-
    % pega os dados do paciente
    write("Digite o nome do paciente:"), nl,
    read(NOME),
    write("Digite o CPF do paciente:"), nl,
    read(CPF),
    write("Digite a idade do paciente:"), nl,
    read(IDADE),
    write("Digite o sexo do paciente:"), nl,
    read(SEXO),
    open('./pacientes.txt',append,Out),
    % guarda o paciente como um fato na memoria

    % escreve no arquivo
    write(Out, NOME),
    write(Out, "|"),
    write(Out, CPF),
    write(Out, "|"),
    write(Out, IDADE),
    write(Out, "|"),
    write(Out, SEXO),
    write(Out, "\n"),
    close(Out).


% Lista todos os pacientes cadastrados em pacientes.txt
listar_pacientes_helper([]).
listar_pacientes_helper([Primeiro|Resto]) :-
    % Separa o registro em uma lista de strings
    split_string(Primeiro, "|", "", [Nome, Cpf, Idade, Sexo]),
    write("------------------------------------------------"), nl,
    write("Nome:  "), write(Nome), nl,
    write("CPF:   "), write(Cpf), nl,
    write("Idade: "), write(Idade), nl,
    write("Sexo:  "), write(Sexo), nl,
    write("------------------------------------------------"), nl,

    listar_pacientes_helper(Resto).

% lista todos pacientes
listar_pacientes :-
    % Le o arquivo e coloca em uma string Arquivo
    read_file_to_string('pacientes.txt', Arquivo, []),
    % Transforma a string Arquivo em uma lista de strings Lista
    % Separacao ocorre no '\n'
    atomic_list_concat(Lista, '\n', Arquivo),
    remove_last(Lista, Lista2),
    write('-------------------Pacientes--------------------'), nl,
    % Printa linha por linha da lista
    listar_pacientes_helper(Lista2),!.
    
    
% Consulta um paciente pelo nome
busca_paciente_helper(_, []).
busca_paciente_helper(Nome, [Registro|Resto]) :-
    % Separa o registro em uma lista de strings
    split_string(Registro, "|", "", [NomeP, Cpf, Idade, Sexo]),
    % transforma os atomos em strings para comparacao correta
    atom_string(Nome, NomeS),
    atom_string(NomeP, NomePS),
    % se o nome do paciente for igual ao nome buscado, printa o registro
    % senao, chama a funcao recursivamente com o resto da lista
    (NomePS = NomeS -> 
        write("------------------------------------------------"), nl,
        write("Nome:  "), write(NomeP), nl,
        write("CPF:   "), write(Cpf), nl,
        write("Idade: "), write(Idade), nl,
        write("Sexo:  "), write(Sexo), nl,
        write("------------------------------------------------"), nl
        ; 
        busca_paciente_helper(Nome, Resto)).
remove_last(List, Result) :-
    append(Result, [_], List).
busca_paciente :-
    nl,
    % espera o usuario digitar o nome a ser buscado
    write("Digite o nome do paciente: "),
    read(NOME),
    % le o arquivo e trasnforma tudo em string separado por '\n'
    read_file_to_string('pacientes.txt', Arquivo, []),
    atomic_list_concat(Lista2, '\n', Arquivo),
    % remove o ultimo elemento pois ele adiciona uma string vazia porque o 
    % arquivo termina com '\n'
    remove_last(Lista2, Lista),
    busca_paciente_helper(NOME, Lista).

% atualiza um registro
edita_paciente(Registro):-
    % le o arquivo e guarda todos os registros em uma lista
    read_file_to_string("pacientes.txt", String, []),
    atomic_list_concat(Lines, '\n', String),
    remove_last(Lines, Lines2),

    % deleta o registro que bater exatamente as informacoes
    delete(Lines2, Registro, Resultado),

    write("Digite o novo nome do paciente:"), nl,
    read(NOME),
    write("Digite a nova idade do paciente:"), nl,
    read(IDADE),
    write("Digite o novo sexo do paciente:"), nl,
    read(SEXO),

    % transforma os atomos em strings
    atom_string(NOME, NOMEstr),
    atom_string(IDADE, IDADEstr),
    atom_string(SEXO, SEXOstr),

    % pega o cpf ja registrado, pois esse nao muda
    split_string(Registro, "|", "", [_, CPF, _, _]),
    % transforma em string tambem
    atom_string(CPF, CPFstr),


    % concatena as strings
    string_concat(NOMEstr, "|", Reg),

    string_concat(Reg, CPFstr, Reg2),
    string_concat(Reg2, "|", Reg3),

    string_concat(Reg3, IDADEstr, Reg4),
    string_concat(Reg4, "|", Reg5),

    string_concat(Reg5, SEXOstr, Reg6),

    
    append(Resultado, [Reg6], Resultado2),
    
    % abre o arquivo como write para sobreescrever 
    open('./pacientes.txt',write,_),

    % recadastra todos os registros
    cadastrar_pacientes(Resultado2).
busca_para_editar(_, []):-
    write("Cadastro nao encontrado!"), nl.
busca_para_editar(Nome, [Registro|Resto]):-
    split_string(Registro, "|", "", [NomeP, _, _, _]),

    % transforma os atomos em strings para comparacao correta
    atom_string(Nome, NomeS),
    atom_string(NomeP, NomePS),

    % se o nome do paciente for igual ao nome buscado, chama a funcao para editar
    (NomePS = NomeS -> 
        write("Cadastro encontrado!"), nl,
        edita_paciente(Registro)
        ; 
        busca_para_editar(Nome, Resto)).
atualiza_paciente:-
    write("Digite o nome do paciente:"), nl,
    read(NOME),
    
    read_file_to_string('pacientes.txt', Arquivo, []),
    atomic_list_concat(Lista, '\n', Arquivo),
    remove_last(Lista, Lista2),

    % chama a funcao recursiva para encontrar o registro
    busca_para_editar(NOME, Lista2).

% exclui um registro
cadastrar_pacientes([]).
cadastrar_pacientes([Primeiro|Resto]) :-
    split_string(Primeiro, "|", "", [Nome, Cpf, Idade, Sexo]),
    open('./pacientes.txt',append,Out),

    % escreve toda a lista no arquivo, 1 por chamada

    write(Out, Nome),
    write(Out, "|"),
    write(Out, Cpf),
    write(Out, "|"),
    write(Out, Idade),
    write(Out, "|"),
    write(Out, Sexo),
    write(Out, "\n"),
    close(Out),
    cadastrar_pacientes(Resto).

busca_para_excluir(_, []):-
    % caso nao encontre o registro
    write("Cadastro nao encontrado!"), nl.
busca_para_excluir(Nome, [Registro|Resto]) :-
    split_string(Registro, "|", "", [NomeP, _, _, _]),
    atom_string(Nome, NomeS),
    atom_string(NomeP, NomePS),
    
    % se o nome do paciente for igual ao nome buscado, exclui o registro
    (NomePS = NomeS -> 
        write("Cadastro encontrado!"), nl,
        exclui_paciente(Registro)
        ; 
        busca_para_excluir(Nome, Resto)).
exclui_paciente:-
    % pega o nome que o usuario deseja excluir
    write("Digite o nome do cadastro a ser excluido"), nl,
    read(NOME),

    % le o arquivo e guarda todos os registros em uma lista
    read_file_to_string('pacientes.txt', Arquivo, []),
    atomic_list_concat(Lista2, '\n', Arquivo),
    remove_last(Lista2, Lista),
    % chama a funcao recursiva para procurar o registro
    busca_para_excluir(NOME, Lista).
exclui_paciente(Registro):-
    % le o arquivo e guarda todos os registros em uma lista
    

    read_file_to_string("pacientes.txt", String, []),
    atomic_list_concat(Lines, '\n', String),
    remove_last(Lines, Lines2),
    

    % deleta o registro que bater exatamente as informacoes
    delete(Lines2, Registro, Resultado),

    % abre o arquivo como write para sobreescrever 
    open('./pacientes.txt',write,_),
    
    % recadastra todos os registros
    cadastrar_pacientes(Resultado).

% teste
teste:-
    % salva os registro para comparar depois

    read_file_to_string('pacientes.txt', Arquivo, []),
    atomic_list_concat(Lista, '\n', Arquivo),
    remove_last(Lista, Lista2),

    % adiciona um registro : Teste|0|0|T
    cadastrar_pacientes(["teste|0|0|T"]),
    nl,write("Teste de adicao de paciente"), nl,
    
    % exclui o registro : Teste|0|0|T

    exclui_paciente('teste|0|0|T'),
    nl,write("Teste de exclusao de paciente"), nl,

    % confere para ver se a lista de registro esta igual a anterior
    read_file_to_string('pacientes.txt', Arquivo2, []),
    atomic_list_concat(Lista3, '\n', Arquivo2),
    remove_last(Lista3, Lista4),

    % se a lista for igual, o teste passou
    (Lista2 = Lista4 -> 
        write("Teste passou!"), nl
        ; 
        write("Teste falhou!"), nl).




