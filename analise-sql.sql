--1) quantos chamados foram abertos no dia 01/04/2023 usando a tabela chamado
SELECT
    COUNT(*)
  FROM
    datario.adm_central_atendimento_1746.chamado AS c
  WHERE 
    DATE(c.data_inicio) = '2023-04-01';

-- 2) Qual o tipo de chamado que teve mais chamados abertos no dia 01/04/2023

SELECT
    c.tipo, COUNT(c.tipo) AS total_chamados
  FROM
    datario.adm_central_atendimento_1746.chamado AS c
  WHERE 
    DATE(c.data_inicio) = '2023-04-01'
  GROUP BY c.tipo
  ORDER BY total_chamados DESC
  LIMIT 1;

-- 3) Quais os nomes dos 3 bairros que tiveram mais chamados abertos nesse dia?

SELECT
    b.nome,
    COUNT(c.id_chamado) AS total_chamados
  FROM
    datario.adm_central_atendimento_1746.chamado AS c
  LEFT JOIN datario.dados_mestres.bairro AS b
    ON b.id_bairro = c.id_bairro
  WHERE 
    DATE(c.data_inicio) = '2023-04-01'
  GROUP BY b.nome
    ORDER BY total_chamados DESC
    LIMIT 4;

-- 4) Qual o nome da subprefeitura com mais chamados abertos nesse dia?

SELECT
    b.subprefeitura,
    COUNT(c.id_chamado) AS total_chamados
  FROM
    datario.adm_central_atendimento_1746.chamado AS c
  LEFT JOIN datario.dados_mestres.bairro AS b
    ON b.id_bairro = c.id_bairro
  WHERE 
    DATE(c.data_inicio) = '2023-04-01'
  GROUP BY b.subprefeitura
    ORDER BY total_chamados DESC
    LIMIT 1;

-- 5) Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura?

SELECT
    c.tipo,
    c.id_bairro,
    b.subprefeitura,
    COUNT(c.id_chamado) AS total_chamados
FROM
    datario.adm_central_atendimento_1746.chamado AS c
LEFT JOIN 
    datario.dados_mestres.bairro AS b
    ON b.id_bairro = c.id_bairro
WHERE 
    DATE(c.data_inicio) = '2023-04-01'
    AND (b.nome IS NULL OR b.subprefeitura IS NULL)
GROUP BY 
    c.tipo,
    c.id_bairro,
    b.subprefeitura
ORDER BY 
    total_chamados DESC;

-- 6) Quantos chamados com o subtipo Perturbação do sossego foram abertos desde 01/01/2022 até 31/12/2023, inclusos?

SELECT
   COUNT(c.id_chamado) AS total_chamados
FROM
    datario.adm_central_atendimento_1746.chamado AS c
WHERE
  c.subtipo = 'Perturbação do sossego'
  AND DATE(c.data_inicio) BETWEEN '2022-01-01' AND '2023-12-31';

-- 7) Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos:

SELECT
   *
FROM
    datario.adm_central_atendimento_1746.chamado AS c
LEFT JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos AS e
  ON DATE(c.data_inicio) = e.data_inicial
WHERE
  c.subtipo = 'Perturbação do sossego'
  AND DATE(c.data_inicio) BETWEEN '2022-01-01' AND '2023-12-31'
  AND e.evento IS NOT NULL;

-- 8) Quantos chamados desse subtipo foram abertos em cada evento:

SELECT
  e.evento,
   COUNT(c.id_chamado) AS total_chamados
FROM
    datario.adm_central_atendimento_1746.chamado AS c
LEFT JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos AS e
  ON DATE(c.data_inicio) = e.data_inicial
WHERE
  c.subtipo = 'Perturbação do sossego'
  AND DATE(c.data_inicio) BETWEEN '2022-01-01' AND '2023-12-31'
  AND e.evento IS NOT NULL
GROUP BY e.evento;