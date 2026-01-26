/**
 * @file SessionServiceV1
 * @description Orchestrates session retrieval for API v1.
 * @layer Service
 * @patterns Facade
 * @author IA
 * @date 2026-01-25
 */
public with sharing class SessionServiceV1 {
    /**
     * @description Returns upcoming sessions in a paginated response.
     * @param page Page number.
     * @param pageSize Page size.
     * @return PaginatedResponseDTO with SessionDTO items.
     * @throws ApiException When validation fails.
     */
    public PaginatedResponseDTO getUpcoming(Integer page, Integer pageSize) {
        Integer offsetValue = (page - 1) * pageSize;
        List<Session__c> records = SessionDAO.fetchUpcoming(pageSize, offsetValue);
        Integer total = SessionDAO.countUpcoming();

        PaginatedResponseDTO response = new PaginatedResponseDTO();
        response.items = new List<Object>();
        for (SessionDTO dto : SessionMapper.toDtos(records)) {
            response.items.add(dto);
        }
        response.page = page;
        response.pageSize = pageSize;
        response.total = total;
        return response;
    }

    /**
     * @description Returns past sessions within a datetime range.
     * @param fromDt Start datetime.
     * @param toDt End datetime.
     * @param page Page number.
     * @param pageSize Page size.
     * @return PaginatedResponseDTO with SessionDTO items.
     * @throws ApiException When validation fails.
     */
    public PaginatedResponseDTO getPast(Datetime fromDt, Datetime toDt, Integer page, Integer pageSize) {
        if (fromDt == null || toDt == null) {
            throw new ApiException(400, 'INVALID_PARAMETER', 'from and to are required.', null);
        }
        if (fromDt > toDt) {
            throw new ApiException(400, 'INVALID_PARAMETER', 'from must be before to.', null);
        }

        Integer offsetValue = (page - 1) * pageSize;
        List<Session__c> records = SessionDAO.fetchPast(fromDt, toDt, pageSize, offsetValue);
        Integer total = SessionDAO.countPast(fromDt, toDt);

        PaginatedResponseDTO response = new PaginatedResponseDTO();
        response.items = new List<Object>();
        for (SessionDTO dto : SessionMapper.toDtos(records)) {
            response.items.add(dto);
        }
        response.page = page;
        response.pageSize = pageSize;
        response.total = total;
        return response;
    }
}
