/**
 * @file RequestControllerV1
 * @description REST controller for request endpoints.
 * @layer Controller
 * @patterns Front Controller
 * @author IA
 * @date 2026-01-25
 */
@RestResource(urlMapping='/api/v1/requests')
global with sharing class RequestControllerV1 {
    private static final Integer DEFAULT_PAGE = 1;
    private static final Integer DEFAULT_PAGE_SIZE = 20;
    private static final Integer MAX_PAGE_SIZE = 100;

    /**
     * @description Handles GET requests for listing requests.
     * @param none
     * @return void
     * @throws ApiException When request is invalid.
     */
    @HttpGet
    global static void doGet() {
        try {
            AuthUtil.requireAuth();

            RestRequest request = RestContext.request;
            String path = ControllerUtil.normalizePath(request != null ? request.resourcePath : null);
            if (path != '/api/v1/requests') {
                ControllerUtil.sendError(404, 'NOT_FOUND', 'Endpoint not found.', new Map<String, Object>{
                    'path' => path
                });
                return;
            }

            String sortParam = getParam(request, 'sort');
            Integer page = ControllerUtil.parsePositiveInt(getParam(request, 'page'), DEFAULT_PAGE, 'page');
            Integer pageSize = ControllerUtil.parsePositiveInt(getParam(request, 'pageSize'), DEFAULT_PAGE_SIZE, 'pageSize');
            ControllerUtil.validatePagination(page, pageSize, MAX_PAGE_SIZE);

            PaginatedResponseDTO response = new RequestServiceV1().listRequests(sortParam, page, pageSize);
            ControllerUtil.sendJson(response, 200);
        } catch (ApiException ex) {
            ControllerUtil.sendError(ex);
        } catch (QueryException ex) {
            ControllerUtil.sendError(403, 'FORBIDDEN', 'Missing object or field permissions.', null);
        } catch (Exception ex) {
            ControllerUtil.sendError(500, 'INTERNAL', 'Unexpected error.', null);
        }
    }

    /**
     * @description Handles POST requests for creating a request.
     * @param none
     * @return void
     * @throws ApiException When request is invalid.
     */
    @HttpPost
    global static void doPost() {
        try {
            AuthUtil.requireAuth();

            RestRequest request = RestContext.request;
            String path = ControllerUtil.normalizePath(request != null ? request.resourcePath : null);
            if (path != '/api/v1/requests') {
                ControllerUtil.sendError(404, 'NOT_FOUND', 'Endpoint not found.', new Map<String, Object>{
                    'path' => path
                });
                return;
            }

            String body = request != null && request.requestBody != null
                ? request.requestBody.toString()
                : null;
            CreateRequestDTO input;
            try {
                input = (CreateRequestDTO) JSON.deserialize(body, CreateRequestDTO.class);
            } catch (Exception ex) {
                throw new ApiException(400, 'INVALID_PARAMETER', 'Invalid JSON body.', null);
            }

            RequestDTO created = new RequestServiceV1().create(input);
            ControllerUtil.sendJson(created, 201);
        } catch (ApiException ex) {
            ControllerUtil.sendError(ex);
        } catch (DmlException ex) {
            ControllerUtil.sendError(403, 'FORBIDDEN', 'Missing create permission.', null);
        } catch (Exception ex) {
            ControllerUtil.sendError(500, 'INTERNAL', 'Unexpected error.', null);
        }
    }

    private static String getParam(RestRequest request, String name) {
        return request != null ? request.params.get(name) : null;
    }
}
