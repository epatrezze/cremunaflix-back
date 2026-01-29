/**
 * @file ApiV1Controller
 * @description Single entrypoint REST controller for API v1 routing.
 * @layer Controller
 * @patterns Front Controller
 * @author epatrezze
 * @date 2026-01-27
 */
@RestResource(urlMapping='/api/v1/*')
global without sharing class ApiV1Controller {
    private static final Integer DEFAULT_PAGE = 1;
    private static final Integer DEFAULT_PAGE_SIZE = 20;
    private static final Integer MAX_PAGE_SIZE = 100;

    /**
     * @description Handles GET requests for API v1.
     * @return void
     */
    @HttpGet
    global static void doGet() {
        route('GET');
    }

    /**
     * @description Handles POST requests for API v1.
     * @return void
     */
    @HttpPost
    global static void doPost() {
        route('POST');
    }

    private static void route(String method) {
        try {
            RestRequest request = RestContext.request;
            String path = resolveRequestPath(request);

            if (method == 'GET' && path == '/api/v1/home') {
                HomeDTO payload = new HomeService().getHome();
                sendJson(payload, 200);
                return;
            }

            if (method == 'GET' && path == '/api/v1/movies') {
                MovieQueryParams params = buildMovieQuery(request);
                Integer page = parsePositiveInt(getParam(request, 'page'), DEFAULT_PAGE, 'page');
                Integer pageSize = parsePositiveInt(getParam(request, 'pageSize'), DEFAULT_PAGE_SIZE, 'pageSize');
                validatePageSize(pageSize);
                PagedResponseDTO payload = new MovieService().listMovies(params, page, pageSize);
                sendJson(payload, 200);
                return;
            }

            if (method == 'GET' && path == '/api/v1/sessions') {
                String scope = getParam(request, 'scope');
                Integer page = parsePositiveInt(getParam(request, 'page'), DEFAULT_PAGE, 'page');
                Integer pageSize = parsePositiveInt(getParam(request, 'pageSize'), DEFAULT_PAGE_SIZE, 'pageSize');
                validatePageSize(pageSize);
                PagedResponseDTO payload = new SessionService().listSessions(scope, page, pageSize);
                sendJson(payload, 200);
                return;
            }

            if (method == 'GET' && (path == '/api/v1/sessions/upcoming' || path == '/api/v1/sessions/past')) {
                String scope = path.endsWith('/past') ? 'past' : 'upcoming';
                Integer page = parsePositiveInt(getParam(request, 'page'), DEFAULT_PAGE, 'page');
                Integer pageSize = parsePositiveInt(getParam(request, 'pageSize'), DEFAULT_PAGE_SIZE, 'pageSize');
                validatePageSize(pageSize);
                PagedResponseDTO payload = new SessionService().listSessions(scope, page, pageSize);
                sendJson(payload, 200);
                return;
            }

            if (method == 'GET' && path == '/api/v1/requests') {
                Integer page = parsePositiveInt(getParam(request, 'page'), DEFAULT_PAGE, 'page');
                Integer pageSize = parsePositiveInt(getParam(request, 'pageSize'), DEFAULT_PAGE_SIZE, 'pageSize');
                validatePageSize(pageSize);
                String sortParam = getParam(request, 'sort');
                PagedResponseDTO payload = new RequestService().listRequests(page, pageSize, sortParam);
                sendJson(payload, 200);
                return;
            }

            if (method == 'POST' && path == '/api/v1/requests') {
                String body = request != null && request.requestBody != null
                    ? request.requestBody.toString()
                    : null;
                RequestCreateDTO input;
                try {
                    input = (RequestCreateDTO) JSON.deserialize(body, RequestCreateDTO.class);
                } catch (Exception ex) {
                    throw new ValidationException('Invalid JSON body.', null);
                }
                RequestDTO created = new RequestService().create(input);
                sendJson(created, 201);
                return;
            }

            throw new NotFoundException('Endpoint not found.', new Map<String, Object>{
                'path' => path,
                'method' => method
            });
        } catch (ApiException ex) {
            sendError(ex);
        } catch (Exception ex) {
            sendError(500, 'INTERNAL', 'Unexpected error.', null);
        }
    }

    private static MovieQueryParams buildMovieQuery(RestRequest request) {
        MovieQueryParams params = new MovieQueryParams();
        params.query = getParam(request, 'query');
        params.status = getParam(request, 'status');
        params.sortValue = getParam(request, 'sort');

        String yearRaw = getParam(request, 'year');
        if (!String.isBlank(yearRaw)) {
            try {
                params.year = Integer.valueOf(yearRaw);
            } catch (Exception ex) {
                throw new ValidationException('Invalid parameter: year.', new Map<String, Object>{
                    'param' => 'year',
                    'value' => yearRaw
                });
            }
        }

        String genreParam = getParam(request, 'genreId');
        if (!String.isBlank(genreParam)) {
            params.genreIds = GenreDAO.resolveGenreIds(genreParam);
            if (params.genreIds.isEmpty()) {
                throw new ValidationException('Genre not found.', new Map<String, Object>{
                    'param' => 'genreId',
                    'value' => genreParam
                });
            }
        }
        return params;
    }

    private static String getParam(RestRequest request, String name) {
        return request != null ? request.params.get(name) : null;
    }

    private static Integer parsePositiveInt(String rawValue, Integer defaultValue, String paramName) {
        if (String.isBlank(rawValue)) {
            return defaultValue;
        }
        Integer parsedValue;
        try {
            parsedValue = Integer.valueOf(rawValue);
        } catch (Exception ex) {
            throw new ValidationException('Invalid parameter: ' + paramName + '.', new Map<String, Object>{
                'param' => paramName,
                'value' => rawValue,
                'reason' => 'must be an integer'
            });
        }
        if (parsedValue < 1) {
            throw new ValidationException('Invalid parameter: ' + paramName + '.', new Map<String, Object>{
                'param' => paramName,
                'value' => rawValue,
                'reason' => 'must be >= 1'
            });
        }
        return parsedValue;
    }

    private static void validatePageSize(Integer pageSize) {
        if (pageSize > MAX_PAGE_SIZE) {
            throw new ValidationException('Invalid parameter: pageSize.', new Map<String, Object>{
                'param' => 'pageSize',
                'value' => String.valueOf(pageSize),
                'reason' => 'max value ' + MAX_PAGE_SIZE
            });
        }
    }

    // requestURI can include /services/apexrest while resourcePath may not, so normalize to /api/v1/*.
    private static String resolveRequestPath(RestRequest request) {
        if (request == null) {
            return '';
        }

        String raw = request.requestURI;
        if (String.isBlank(raw)) {
            raw = request.resourcePath;
        }

        if (String.isBlank(raw)) {
            return '';
        }

        Integer queryIndex = raw.indexOf('?');
        if (queryIndex >= 0) {
            raw = raw.substring(0, queryIndex);
        }

        if (raw.startsWith('/services/apexrest')) {
            raw = raw.substring('/services/apexrest'.length());
        }

        return normalizePath(raw);
    }

    private static String normalizePath(String path) {
        if (String.isBlank(path)) {
            return '';
        }
        if (path.endsWith('/')) {
            return path.substring(0, path.length() - 1);
        }
        return path;
    }

    private static void sendJson(Object payload, Integer statusCode) {
        RestResponse response = RestContext.response;
        addCorsHeaders(response);
        response.statusCode = statusCode;
        response.addHeader('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(JSON.serialize(payload));
    }

    private static void addCorsHeaders(RestResponse response) {
        if (response == null) {
            return;
        }
        response.addHeader('Access-Control-Allow-Origin', resolveAllowedOrigin());
        response.addHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
        response.addHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
        response.addHeader('Access-Control-Max-Age', '3600');
    }

    private static String resolveAllowedOrigin() {
        RestRequest request = RestContext.request;
        if (request == null || request.headers == null) {
            return '*';
        }
        String origin = request.headers.get('Origin');
        return String.isBlank(origin) ? '*' : origin;
    }

    private static void sendError(ApiException ex) {
        ErrorDTO errorPayload = new ErrorDTO();
        errorPayload.code = ex.code;
        errorPayload.message = ex.message != null ? ex.message : ex.getMessage();
        errorPayload.details = ex.details;
        sendJson(errorPayload, ex.httpStatus);
    }

    private static void sendError(Integer statusCode, String code, String message, Object details) {
        sendError(new ApiException(statusCode, code, message, details));
    }
}
