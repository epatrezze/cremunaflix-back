/**
 * @file RequestService
 * @description Orchestrates movie request listing and creation for API v1.
 * @layer Service
 * @patterns Facade
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class RequestService {
    /**
     * @description Returns requests in a paginated response.
     * @param page Page number.
     * @param pageSize Page size.
     * @param sortParam Sort parameter.
     * @return PagedResponseDTO with RequestDTO items.
     */
    public PagedResponseDTO listRequests(Integer page, Integer pageSize, String sortParam) {
        Integer offsetValue = (page - 1) * pageSize;
        List<MovieRequest__c> records = RequestDAO.fetchRequests(offsetValue, pageSize, sortParam);
        Integer total = RequestDAO.countRequests();

        List<Object> items = new List<Object>();
        for (MovieRequest__c record : records) {
            items.add(toDto(record));
        }

        return buildResponse(items, page, pageSize, total);
    }

    /**
     * @description Creates a new request after validation.
     * @param input RequestCreateDTO payload.
     * @return RequestDTO of created record.
     */
    public RequestDTO create(RequestCreateDTO input) {
        if (input == null) {
            throw new ValidationException('Request body is required.', null);
        }
        if (String.isBlank(input.title)) {
            throw new ValidationException('Title is required.', new Map<String, Object>{
                'field' => 'title'
            });
        }

        Id requestedById = resolveRequestedById(input);

        MovieRequest__c record = new MovieRequest__c();
        record.RequestedBy__c = requestedById;
        record.Title__c = input.title != null ? input.title.trim() : null;
        record.TMDB_Id__c = input.tmdbId;
        record.PosterUrl__c = input.posterUrl;
        record.Notes__c = input.notes;

        if (!String.isBlank(input.tmdbId)) {
            Movie__c movie = MovieDAO.fetchByTmdbId(input.tmdbId.trim());
            if (movie != null) {
                record.Movie__c = movie.Id;
            }
        }

        Id createdId = RequestDAO.insertRequest(record);
        MovieRequest__c saved = RequestDAO.fetchById(createdId);
        if (saved == null) {
            throw new ApiException(500, 'INTERNAL', 'Failed to load created request.', null);
        }
        return toDto(saved);
    }

    /**
     * @description Returns most requested movies.
     * @param limitSize Max number of records.
     * @return List of MovieSummaryDTO.
     */
    public List<MovieSummaryDTO> getMostRequestedMovies(Integer limitSize) {
        List<Id> movieIds = RequestDAO.fetchMostRequestedMovieIds(limitSize);
        return new MovieService().getSummariesByIds(movieIds);
    }

    private static Id resolveRequestedById(RequestCreateDTO input) {
        if (input != null && !String.isBlank(input.requestedById)) {
            try {
                return (Id) input.requestedById;
            } catch (Exception ex) {
                throw new ValidationException('Invalid parameter: requestedById.', new Map<String, Object>{
                    'param' => 'requestedById',
                    'value' => input.requestedById
                });
            }
        }

        List<Contact> contacts = [
            SELECT Id FROM Contact WHERE Email = :UserInfo.getUserEmail() LIMIT 1
        ];
        if (!contacts.isEmpty()) {
            return contacts[0].Id;
        }

        throw new ValidationException('requestedById is required.', new Map<String, Object>{
            'field' => 'requestedById'
        });
    }

    private static RequestDTO toDto(MovieRequest__c record) {
        if (record == null) {
            return null;
        }
        RequestDTO dto = new RequestDTO();
        dto.id = String.valueOf(record.Id);
        dto.status = record.Status__c;
        dto.requestedAt = DateTimeUtil.formatIso(record.CreatedDate);
        dto.requestedBy = record.RequestedBy__r != null ? record.RequestedBy__r.Name : null;
        dto.tmdbId = record.TMDB_Id__c;
        dto.title = record.Title__c;
        dto.posterUrl = record.PosterUrl__c;
        dto.movie = MovieMapper.toSummary(record.Movie__r);
        return dto;
    }

    private static PagedResponseDTO buildResponse(List<Object> items, Integer page, Integer pageSize, Integer totalItems) {
        PagedResponseDTO response = new PagedResponseDTO();
        response.items = items;

        PageInfoDTO pageInfo = new PageInfoDTO();
        pageInfo.page = page;
        pageInfo.pageSize = pageSize;
        pageInfo.totalItems = totalItems;
        pageInfo.totalPages = pageSize > 0
            ? (Integer) Math.ceil((Decimal) totalItems / pageSize)
            : 0;
        response.pageInfo = pageInfo;
        return response;
    }
}
