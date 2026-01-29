# Cremunaflix Back (Apex REST) 🎬

Projeto de estudo de implantacao em Salesforce, ainda em desenvolvimento. O foco e criar um backend Apex REST para um front React (GitHub Pages), usando boas praticas de arquitetura e separacao de responsabilidades. 🚧

## Objetivo

- Expor rotas REST v1 para sessions e requests.
- Manter o codigo organizado por camadas e patterns.
- Preparar terreno para auth (OAuth PKCE) e CORS.

## Status

- Em desenvolvimento (nao usar como referencia de producao). ⚠️

## Padroes e arquitetura 🧱

- DTO: contratos de entrada/saida (`HomeDTO`, `RequestDTO`, `RequestCreateDTO`, `PagedResponseDTO`).
- DAO: acesso a dados centralizado (`SessionDAO`, `RequestDAO`, `MovieDAO`, `GenreDAO`).
- Mapper: conversao SObject -> DTO (`MovieMapper`).
- Service/Facade: orquestracao de regras (`HomeService`, `SessionService`, `MovieService`, `RequestService`).
- Exception handling: `ApiException` + `ErrorDTO` para respostas padronizadas.

## Estrutura de classes por responsabilidade 📚

- Controller (REST):
  - `ApiV1Controller`
- Services:
  - `HomeService`
  - `SessionService`
  - `MovieService`
  - `RequestService`
- DAOs:
  - `SessionDAO`
  - `RequestDAO`
  - `MovieDAO`
  - `GenreDAO`
- Mappers:
  - `MovieMapper`
- DTOs:
  - `HomeDTO`
  - `HomeHeroDTO`
  - `MovieDTO`
  - `MovieSummaryDTO`
  - `MovieMetricsDTO`
  - `MovieImagesDTO`
  - `SessionDTO`
  - `RequestDTO`
  - `RequestCreateDTO`
  - `PagedResponseDTO`
  - `PageInfoDTO`
  - `ErrorDTO`
  - `GenreDTO`
- Exceptions:
  - `ApiException`
  - `ValidationException`
  - `NotFoundException`
- Utils:
  - `DateTimeUtil`

## Rotas disponiveis 📌

- `GET /services/apexrest/api/v1/home`
- `GET /services/apexrest/api/v1/movies?query=&status=&year=&genreId=&sort=&page=&pageSize=`
- `GET /services/apexrest/api/v1/sessions?scope=upcoming|past&page=&pageSize=`
- `GET /services/apexrest/api/v1/requests?sort=&page=&pageSize=`
- `POST /services/apexrest/api/v1/requests`

Compatibilidade (legado):
- `GET /services/apexrest/api/v1/sessions/upcoming`
- `GET /services/apexrest/api/v1/sessions/past`

## Como usar 🛠️

1) Autenticar no org:
```bash
sf org login web --alias dev
```

2) Deploy do metadata:
```bash
sf project deploy start --source-dir force-app
```

3) Configurar no Salesforce:
- CORS Allowlist com o dominio do GitHub Pages.
- Permission Set para acesso aos objetos/campos e classes Apex.
- (Opcional) OAuth PKCE para o front.

4) Testar endpoints (Workbench/Postman):
- Base URL: `https://<mydomain>.my.salesforce.com/services/apexrest`
- Exemplo GET home:
  - `GET /api/v1/home`
- Exemplo POST request:
```json
{
  "title": "The Matrix",
  "tmdbId": "603",
  "posterUrl": "https://image.tmdb.org/t/p/w342/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
  "notes": "Quero esse filme",
  "requestedById": "003000000000000AAA"
}
```

## Observacoes importantes ✅

- API sempre retorna DTOs (nunca SObject direto).
- Datas em ISO-8601 UTC.
- A origem do front precisa apontar para o dominio Salesforce (com `/services/apexrest`).

## Problemas comuns 🧯

- Erro `404` com HTML do GitHub Pages: a chamada esta indo para o dominio do front.
  Ajuste o `baseURL` do front para `https://<mydomain>.my.salesforce.com/services/apexrest`.

## Contribuicao

Pull requests sao bem-vindos. Abra uma issue para discutir mudancas maiores. 🙂
