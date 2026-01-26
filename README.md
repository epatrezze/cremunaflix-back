# Cremunaflix Back (Apex REST) 🎬

Projeto de estudo de implantacao em Salesforce, ainda em desenvolvimento. O foco e criar um backend Apex REST para um front React (GitHub Pages), usando boas praticas de arquitetura e separacao de responsabilidades. 🚧

## Objetivo

- Expor rotas REST v1 para sessions e requests.
- Manter o codigo organizado por camadas e patterns.
- Preparar terreno para auth (OAuth PKCE) e CORS.

## Status

- Em desenvolvimento (nao usar como referencia de producao). ⚠️

## Padroes e arquitetura 🧱

- DTO: contratos de entrada/saida (`SessionDTO`, `RequestDTO`, `CreateRequestDTO`).
- DAO: acesso a dados centralizado (`SessionDAO`, `RequestDAO`, `FilmDAO`).
- Mapper: conversao SObject -> DTO (`SessionMapper`, `RequestMapper`, `FilmMapper`).
- Service/Facade: orquestracao de regras (`SessionServiceV1`, `RequestServiceV1`).
- Chain of Responsibility: validacao de POST /requests (`RequestValidator`, `RequiredFieldsValidator`, `BusinessRulesValidator`, `PermissionValidator`).
- Exception handling: `ApiException` + `ControllerUtil` para respostas padronizadas.

## Estrutura de classes por responsabilidade 📚

- Controllers (REST):
  - `SessionControllerV1`
  - `RequestControllerV1`
- Services:
  - `SessionServiceV1`
  - `RequestServiceV1`
- DAOs:
  - `SessionDAO`
  - `RequestDAO`
  - `FilmDAO`
- Mappers:
  - `SessionMapper`
  - `RequestMapper`
  - `FilmMapper`
- DTOs:
  - `SessionDTO`
  - `RequestDTO`
  - `CreateRequestDTO`
  - `PaginatedResponseDTO`
  - `ApiErrorDTO`
- Validators:
  - `RequestValidator`
  - `RequiredFieldsValidator`
  - `BusinessRulesValidator`
  - `PermissionValidator`
- Utils:
  - `DateTimeUtil`
  - `AuthUtil`
  - `ControllerUtil`

## Rotas disponiveis 📌

- `GET /services/apexrest/api/v1/sessions/upcoming`
- `GET /services/apexrest/api/v1/sessions/past?from=&to=`
- `GET /services/apexrest/api/v1/requests?sort=&page=&pageSize=`
- `POST /services/apexrest/api/v1/requests`

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
- Exemplo GET upcoming:
  - `GET /api/v1/sessions/upcoming`
- Exemplo POST request:
```json
{
  "requesterName": "Maria",
  "requestedTitle": "The Matrix",
  "requestedYear": 1999,
  "notes": "Quero esse filme",
  "priority": "HIGH"
}
```

## Observacoes importantes ✅

- API sempre retorna DTOs (nunca SObject direto).
- Datas em ISO-8601 UTC.
- `AuthUtil.enforceAuth` esta desativado por padrao (modo dev).

## Contribuicao

Pull requests sao bem-vindos. Abra uma issue para discutir mudancas maiores. 🙂
