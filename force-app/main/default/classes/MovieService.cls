/**
 * @file MovieService
 * @description Orchestrates movie listing for API v1.
 * @layer Service
 * @patterns Facade
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class MovieService {
    /**
     * @description Returns movies in a paginated response.
     * @param params Query params.
     * @param page Page number.
     * @param pageSize Page size.
     * @return PagedResponseDTO with MovieDTO items.
     */
    public PagedResponseDTO listMovies(MovieQueryParams params, Integer page, Integer pageSize) {
        Integer offsetValue = (page - 1) * pageSize;
        List<Movie__c> records = MovieDAO.fetchMovies(params, offsetValue, pageSize);
        Integer total = MovieDAO.countMovies(params);

        List<Object> items = new List<Object>();
        for (Movie__c record : records) {
            items.add(MovieMapper.toDto(record));
        }

        return buildResponse(items, page, pageSize, total);
    }

    /**
     * @description Returns summaries for the given Movie__c ids.
     * @param movieIds Movie ids.
     * @return List of MovieSummaryDTO.
     */
    public List<MovieSummaryDTO> getSummariesByIds(List<Id> movieIds) {
        if (movieIds == null || movieIds.isEmpty()) {
            return new List<MovieSummaryDTO>();
        }
        Map<Id, Movie__c> movieMap = new Map<Id, Movie__c>(MovieDAO.fetchByIds(new Set<Id>(movieIds)));
        List<MovieSummaryDTO> results = new List<MovieSummaryDTO>();
        for (Id movieId : movieIds) {
            Movie__c record = movieMap.get(movieId);
            if (record != null) {
                results.add(MovieMapper.toSummary(record));
            }
        }
        return results;
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
