Usando a Collection no Postman

## Introdução

Este documento fornece orientações sobre como usar a coleção do Postman para testar a API. A coleção contém todas as requisições necessárias para interagir com a API e verificar suas funcionalidades.

## Pré-requisitos

- **Postman** instalado em seu computador. [Baixar Postman](https://www.postman.com/downloads/)

## Importando a Collection

1. **Abrir o Postman**:
   - Inicie o aplicativo Postman.

2. **Importar a Collection**:
   - Clique no botão `Import` no canto superior esquerdo.
   - Aarraste o arquivo `ServeRest Neoway.postman_collection.json` JSON para a área de importação ou clique em `select files` e localize o arquivo.
   - Clique em `Import` para adicionar a coleção à sua lista.

3. **Visualizar a Collection**:
   - Após a importação, você verá a coleção listada no painel lateral. Clique nela para expandir e visualizar as requisições disponíveis.

## Usando as Requisições

1. **Selecionar uma Requisição**:
   - No painel da coleção, clique em uma requisição que você deseja testar.

2. **Executar a Requisição**:
   - Clique no botão `Send` para executar a requisição.
   - Veja a resposta no painel inferior.

## Testes Automatizados

Para visualizar os testes automatizados, clicar na aba `Scripts`, `Post-response` após enviar a requisição. Os resultados dos testes aparecerão na seção de Response.

## Testes de Performance

1. **Usar o Collection Runner**:
   - Selecione a pasta de Usuários
   - Clique nos 3 pontinhos
   - Clique no botão `Run folder` no rodapé do Postman.
   - Selecione apenas a requisição `GET Listar Usuários Cadastrados`
   - Na aba `Performance`, altere para 5 a opção `Virtal users`, e 5 mins em `Test duration`

2. **Executar o Teste**:
   - Clique em `Run` para iniciar o teste de performance.
   - O Postman exibirá os resultados das requisições, incluindo tempos de resposta e estatísticas gerais.

5. **Analisar Resultados**:
   - Após a execução, será possível identificar os dados de performance, incluindo o tempo médio de resposta, taxa de erro, total de requisições efetuadas, entre outras informações.
