# Cremunaflix Back (Apex REST) 🎬

Projeto de estudo de implantacao em Salesforce, ainda em desenvolvimento. O foco e criar um backend Apex REST para um front React (GitHub Pages), usando boas praticas de arquitetura e separacao de responsabilidades. 🚧

## Objetivo

- Expor rotas REST v1 para home, movies, sessions e requests.
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

## Como usar / consumir 🛠️

### Base URL

```
https://<mydomain>.my.salesforce.com/services/apexrest
```

### Autenticacao

- Requer autenticacao Salesforce (ex.: OAuth com `Authorization: Bearer <access_token>`).
- Alternativamente, use uma sessao ativa no Workbench/Postman.

### Paginacao

- `page` default: `1`
- `pageSize` default: `20`
- `pageSize` max: `100`

### Parametros importantes

- `movies`:
  - `sort`: `releaseDate_desc` (default), `voteAverage_desc`, `popularity_desc`
  - `genreId`: aceita Salesforce Id **ou** TMDB numeric id
- `sessions`:
  - `scope`: `upcoming` (default) ou `past`
- `requests`:
  - `sort`: `requestedAt_desc` (default) ou `requestedAt_asc`

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

## Endpoints e exemplos 📌

### GET /api/v1/home

Retorna destaque (hero) e listas resumidas.

Exemplo de resposta:
```json
{
  "hero": {
    "title": "Ultimas sessoes",
    "items": [
      {
        "id": "a0B000000000001",
        "startDateTime": "2026-01-29T20:00:00Z",
        "status": "UPCOMING",
        "movie": {
          "id": "a0M000000000001",
          "tmdbId": "603",
          "title": "The Matrix",
          "releaseYear": 1999,
          "posterUrl": "https://image.tmdb.org/t/p/w342/matrix.jpg",
          "status": "EXHIBITED"
        }
      }
    ]
  },
  "lastExhibited": [
    {
      "id": "a0M000000000002",
      "tmdbId": "157336",
      "title": "Interstellar",
      "releaseYear": 2014,
      "posterUrl": "https://image.tmdb.org/t/p/w342/interstellar.jpg",
      "status": "EXHIBITED"
    }
  ],
  "mostRequested": [
    {
      "id": "a0M000000000003",
      "tmdbId": "693134",
      "title": "Dune: Part Two",
      "releaseYear": 2024,
      "posterUrl": "https://image.tmdb.org/t/p/w342/dune2.jpg",
      "status": "UPCOMING"
    }
  ]
}
```

### GET /api/v1/movies

Query params:
- `query` (texto)
- `status` (ex.: `EXHIBITED`, `UPCOMING`, `REQUESTED`)
- `year`
- `genreId` (Salesforce Id ou TMDB numeric id)
- `sort` (`releaseDate_desc`, `voteAverage_desc`, `popularity_desc`)
- `page`, `pageSize`

Exemplo de request:
```
GET /api/v1/movies?status=EXHIBITED&sort=voteAverage_desc&page=1&pageSize=2
```

Exemplo de resposta:
```json
{
  "items": [
    {
      "id": "a0M000000000001",
      "tmdbId": "603",
      "title": "The Matrix",
      "overview": "A hacker learns reality is a simulation.",
      "releaseDate": "1999-03-31",
      "releaseYear": 1999,
      "runtimeMinutes": 136,
      "imdbUrl": "https://www.imdb.com/title/tt0133093/",
      "images": {
        "posterUrl": "https://image.tmdb.org/t/p/w342/matrix.jpg",
        "backdropUrl": "https://image.tmdb.org/t/p/w780/matrix-bg.jpg"
      },
      "genres": [
        { "id": "a0G000000000001", "tmdbId": "28", "name": "Action" }
      ],
      "metrics": {
        "popularity": 80.43,
        "voteAverage": 8.7,
        "voteCount": 25000
      },
      "status": "EXHIBITED"
    }
  ],
  "pageInfo": { "page": 1, "pageSize": 2, "totalItems": 25, "totalPages": 13 }
}
```

### GET /api/v1/sessions

Query params:
- `scope` (`upcoming` | `past`)
- `page`, `pageSize`

Exemplo de request:
```
GET /api/v1/sessions?scope=upcoming&page=1&pageSize=5
```

Exemplo de resposta:
```json
{
  "items": [
    {
      "id": "a0B000000000010",
      "startDateTime": "2026-02-05T20:00:00Z",
      "status": "UPCOMING",
      "movie": {
        "id": "a0M000000000003",
        "tmdbId": "693134",
        "title": "Dune: Part Two",
        "releaseYear": 2024,
        "posterUrl": "https://image.tmdb.org/t/p/w342/dune2.jpg",
        "status": "UPCOMING"
      }
    }
  ],
  "pageInfo": { "page": 1, "pageSize": 5, "totalItems": 7, "totalPages": 2 }
}
```

Compatibilidade (legado):
```
GET /api/v1/sessions/upcoming
GET /api/v1/sessions/past
```

### GET /api/v1/requests

Query params:
- `sort` (`requestedAt_desc` | `requestedAt_asc`)
- `page`, `pageSize`

Exemplo de request:
```
GET /api/v1/requests?sort=requestedAt_desc&page=1&pageSize=10
```

Exemplo de resposta:
```json
{
  "items": [
    {
      "id": "a0R000000000001",
      "status": "OPEN",
      "requestedAt": "2026-01-29T13:22:10Z",
      "requestedBy": "Ana Silva",
      "tmdbId": "603",
      "title": "The Matrix",
      "posterUrl": "https://image.tmdb.org/t/p/w342/matrix.jpg",
      "movie": {
        "id": "a0M000000000001",
        "tmdbId": "603",
        "title": "The Matrix",
        "releaseYear": 1999,
        "posterUrl": "https://image.tmdb.org/t/p/w342/matrix.jpg",
        "status": "EXHIBITED"
      }
    }
  ],
  "pageInfo": { "page": 1, "pageSize": 10, "totalItems": 12, "totalPages": 2 }
}
```

### POST /api/v1/requests

Body:
```json
{
  "title": "The Matrix",
  "tmdbId": "603",
  "posterUrl": "https://image.tmdb.org/t/p/w342/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
  "notes": "Quero esse filme",
  "requestedById": "003000000000000AAA"
}
```

Exemplo de resposta (201):
```json
{
  "id": "a0R000000000009",
  "status": "OPEN",
  "requestedAt": "2026-01-29T13:40:10Z",
  "requestedBy": "Ana Silva",
  "tmdbId": "603",
  "title": "The Matrix",
  "posterUrl": "https://image.tmdb.org/t/p/w342/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
  "movie": {
    "id": "a0M000000000001",
    "tmdbId": "603",
    "title": "The Matrix",
    "releaseYear": 1999,
    "posterUrl": "https://image.tmdb.org/t/p/w342/matrix.jpg",
    "status": "EXHIBITED"
  }
}
```

## Erros (formato padrao)

Exemplo:
```json
{
  "code": "INVALID_PARAMETER",
  "message": "Invalid parameter: page.",
  "details": { "param": "page", "value": "0", "reason": "must be >= 1" }
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
