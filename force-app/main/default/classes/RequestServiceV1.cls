/**
 * @file RequestServiceV1
 * @description Orchestrates request listing and creation for API v1.
 * @layer Service
 * @patterns Facade
 * @author IA
 * @date 2026-01-25
 */
public with sharing class RequestServiceV1 {
    private static final String DEFAULT_STATUS = 'OPEN';

    /**
     * @description Returns requests in a paginated response.
     * @param sortParam Sort string.
     * @param page Page number.
     * @param pageSize Page size.
     * @return PaginatedResponseDTO with RequestDTO items.
     * @throws ApiException When validation fails.
     */
    public PaginatedResponseDTO listRequests(String sortParam, Integer page, Integer pageSize) {
        Integer offsetValue = (page - 1) * pageSize;
        List<Request__c> records = RequestDAO.fetchList(sortParam, offsetValue, pageSize);
        Integer total = RequestDAO.countTotal();

        PaginatedResponseDTO response = new PaginatedResponseDTO();
        response.items = new List<Object>();
        for (RequestDTO dto : RequestMapper.toDtos(records)) {
            response.items.add(dto);
        }
        response.page = page;
        response.pageSize = pageSize;
        response.total = total;
        return response;
    }

    /**
     * @description Creates a new request after validation.
     * @param input CreateRequestDTO payload.
     * @return RequestDTO of created record.
     * @throws ApiException When validation fails.
     */
    public RequestDTO create(CreateRequestDTO input) {
        buildValidatorChain().validate(input);

        Request__c record = new Request__c();
        record.Status__c = DEFAULT_STATUS;
        record.RequesterName__c = input.requesterName != null ? input.requesterName.trim() : null;
        record.RequesterEmail__c = input.requesterEmail;
        record.RequestedTitle__c = input.requestedTitle != null ? input.requestedTitle.trim() : null;
        record.RequestedYear__c = input.requestedYear;
        record.Notes__c = input.notes;
        record.Priority__c = input.priority;

        if (!String.isBlank(input.filmId)) {
            Film__c filmRecord = resolveFilm(input.filmId);
            if (filmRecord != null) {
                record.Film__c = filmRecord.Id;
            }
        }

        Id createdId = RequestDAO.insertRequest(record);
        Request__c saved = RequestDAO.fetchById(createdId);
        if (saved == null) {
            throw new ApiException(500, 'INTERNAL', 'Failed to load created request.', null);
        }
        return RequestMapper.toDto(saved);
    }

    private static RequestValidator buildValidatorChain() {
        RequestValidator required = new RequiredFieldsValidator();
        RequestValidator business = new BusinessRulesValidator();
        RequestValidator permission = new PermissionValidator();
        required.setNext(business).setNext(permission);
        return required;
    }

    private static Film__c resolveFilm(String filmToken) {
        String trimmed = filmToken != null ? filmToken.trim() : null;
        if (String.isBlank(trimmed)) {
            return null;
        }
        if (isValidId(trimmed)) {
            return FilmDAO.fetchById((Id) trimmed);
        }
        return FilmDAO.fetchByExternalKey(trimmed);
    }

    private static Boolean isValidId(String value) {
        try {
            Id.valueOf(value);
            return true;
        } catch (Exception ex) {
            return false;
        }
    }
}
