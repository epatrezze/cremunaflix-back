/**
 * @file SessionControllerV1
 * @description REST controller for session endpoints.
 * @layer Controller
 * @patterns Front Controller
 * @author IA
 * @date 2026-01-25
 */
@RestResource(urlMapping='/api/v1/sessions/*')
global with sharing class SessionControllerV1 {
    private static final Integer DEFAULT_PAGE = 1;
    private static final Integer DEFAULT_PAGE_SIZE = 20;
    private static final Integer MAX_PAGE_SIZE = 100;

    /**
     * @description Handles GET requests for upcoming and past sessions.
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

            Integer page = ControllerUtil.parsePositiveInt(getParam(request, 'page'), DEFAULT_PAGE, 'page');
            Integer pageSize = ControllerUtil.parsePositiveInt(getParam(request, 'pageSize'), DEFAULT_PAGE_SIZE, 'pageSize');
            ControllerUtil.validatePagination(page, pageSize, MAX_PAGE_SIZE);

            SessionServiceV1 service = new SessionServiceV1();
            if (path.endsWith('/upcoming')) {
                PaginatedResponseDTO response = service.getUpcoming(page, pageSize);
                ControllerUtil.sendJson(response, 200);
                return;
            }
            if (path.endsWith('/past')) {
                String fromRaw = getParam(request, 'from');
                String toRaw = getParam(request, 'to');
                Datetime fromDt = DateTimeUtil.parseIso(fromRaw);
                Datetime toDt = DateTimeUtil.parseIso(toRaw);
                if (fromDt == null || toDt == null) {
                    throw new ApiException(400, 'INVALID_PARAMETER', 'from and to are required.', null);
                }
                PaginatedResponseDTO response = service.getPast(fromDt, toDt, page, pageSize);
                ControllerUtil.sendJson(response, 200);
                return;
            }

            ControllerUtil.sendError(404, 'NOT_FOUND', 'Endpoint not found.', new Map<String, Object>{
                'path' => path
            });
        } catch (ApiException ex) {
            ControllerUtil.sendError(ex);
        } catch (QueryException ex) {
            ControllerUtil.sendError(403, 'FORBIDDEN', 'Missing object or field permissions.', null);
        } catch (Exception ex) {
            ControllerUtil.sendError(500, 'INTERNAL', 'Unexpected error.', null);
        }
    }

    private static String getParam(RestRequest request, String name) {
        return request != null ? request.params.get(name) : null;
    }
}
