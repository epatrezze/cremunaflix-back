/**
 * @file SessionService
 * @description Orchestrates session retrieval for API v1.
 * @layer Service
 * @patterns Facade
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class SessionService {
    /**
     * @description Returns sessions in a paginated response.
     * @param scope upcoming|past.
     * @param page Page number.
     * @param pageSize Page size.
     * @return PagedResponseDTO with SessionDTO items.
     */
    public PagedResponseDTO listSessions(String scope, Integer page, Integer pageSize) {
        String normalized = String.isBlank(scope) ? 'upcoming' : scope.trim().toLowerCase();
        Integer offsetValue = (page - 1) * pageSize;
        List<Session__c> records;
        Integer total;

        if (normalized == 'upcoming') {
            records = SessionDAO.fetchUpcoming(pageSize, offsetValue);
            total = SessionDAO.countUpcoming();
        } else if (normalized == 'past') {
            records = SessionDAO.fetchPast(pageSize, offsetValue);
            total = SessionDAO.countPast();
        } else {
            throw new ValidationException('Invalid parameter: scope.', new Map<String, Object>{
                'param' => 'scope',
                'value' => scope,
                'allowed' => new List<String>{ 'upcoming', 'past' }
            });
        }

        List<Object> items = new List<Object>();
        for (Session__c record : records) {
            items.add(toDto(record));
        }

        return buildResponse(items, page, pageSize, total);
    }

    /**
     * @description Returns recent sessions for home hero.
     * @param limitSize Max number of records.
     * @return List of SessionDTO.
     */
    public List<SessionDTO> getRecentSessions(Integer limitSize) {
        List<Session__c> records = SessionDAO.fetchRecent(limitSize);
        List<SessionDTO> results = new List<SessionDTO>();
        for (Session__c record : records) {
            results.add(toDto(record));
        }
        return results;
    }

    /**
     * @description Returns last exhibited movies based on past sessions.
     * @param limitSize Max number of records.
     * @return List of MovieSummaryDTO.
     */
    public List<MovieSummaryDTO> getLastExhibitedMovies(Integer limitSize) {
        List<Session__c> records = SessionDAO.fetchPast(limitSize, 0);
        Map<Id, MovieSummaryDTO> unique = new Map<Id, MovieSummaryDTO>();
        List<MovieSummaryDTO> results = new List<MovieSummaryDTO>();
        for (Session__c record : records) {
            MovieSummaryDTO summary = MovieMapper.toSummary(record.Movie__r);
            if (summary != null && summary.id != null && !unique.containsKey((Id) summary.id)) {
                unique.put((Id) summary.id, summary);
                results.add(summary);
            }
        }
        return results;
    }

    private static SessionDTO toDto(Session__c record) {
        if (record == null) {
            return null;
        }
        SessionDTO dto = new SessionDTO();
        dto.id = String.valueOf(record.Id);
        dto.startDateTime = DateTimeUtil.formatIso(record.StartDateTime__c);
        dto.status = record.Status__c;
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
