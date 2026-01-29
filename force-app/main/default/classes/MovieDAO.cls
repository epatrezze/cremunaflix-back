/**
 * @file MovieDAO
 * @description SOQL access for Movie__c.
 * @layer DAO
 * @patterns DAO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class MovieDAO {
    private static final String BASE_FIELDS =
        'Id, Title__c, Overview__c, ReleaseDate__c, ReleaseYear__c, RuntimeMinutes__c, ' +
        'IMDB_Url__c, PosterUrl__c, BackdropUrl__c, Status__c, TMDB_Id__c, ' +
        'Popularity__c, VoteAverage__c, VoteCount__c';

    /**
     * @description Fetches movies with filters, sorting, and pagination.
     * @param params Query params.
     * @param offsetValue Offset for pagination.
     * @param limitSize Max number of records.
     * @return List of Movie__c records.
     */
    public static List<Movie__c> fetchMovies(MovieQueryParams params, Integer offsetValue, Integer limitSize) {
        String queryLike;
        Integer yearValue = params != null ? params.year : null;
        String statusValue = params != null ? params.status : null;
        Set<Id> genreIds = params != null ? params.genreIds : null;

        List<String> whereClauses = new List<String>();
        if (params != null && !String.isBlank(params.query)) {
            queryLike = '%' + params.query.trim() + '%';
            whereClauses.add('Title__c LIKE :queryLike');
        }
        if (yearValue != null) {
            whereClauses.add('ReleaseYear__c = :yearValue');
        }
        if (!String.isBlank(statusValue)) {
            whereClauses.add('Status__c = :statusValue');
        }
        if (genreIds != null && !genreIds.isEmpty()) {
            whereClauses.add('Id IN (SELECT Movie__c FROM MovieGenre__c WHERE Genre__c IN :genreIds)');
        }

        String whereClause = whereClauses.isEmpty() ? '' : ' WHERE ' + String.join(whereClauses, ' AND ');
        String orderByClause = buildOrderBy(params != null ? params.sortValue : null);

        String soql =
            'SELECT ' + BASE_FIELDS + ', ' +
            '(SELECT Genre__r.Id, Genre__r.Name, Genre__r.TMDB_GenreId__c FROM MovieGenres__r) ' +
            'FROM Movie__c' +
            whereClause + ' ' +
            orderByClause + ' ' +
            'LIMIT :limitSize OFFSET :offsetValue';

        List<Movie__c> records = Database.query(soql);
        return sanitizeList(records);
    }

    /**
     * @description Counts movies for the provided filters.
     * @param params Query params.
     * @return Total count.
     */
    public static Integer countMovies(MovieQueryParams params) {
        String queryLike;
        Integer yearValue = params != null ? params.year : null;
        String statusValue = params != null ? params.status : null;
        Set<Id> genreIds = params != null ? params.genreIds : null;

        List<String> whereClauses = new List<String>();
        if (params != null && !String.isBlank(params.query)) {
            queryLike = '%' + params.query.trim() + '%';
            whereClauses.add('Title__c LIKE :queryLike');
        }
        if (yearValue != null) {
            whereClauses.add('ReleaseYear__c = :yearValue');
        }
        if (!String.isBlank(statusValue)) {
            whereClauses.add('Status__c = :statusValue');
        }
        if (genreIds != null && !genreIds.isEmpty()) {
            whereClauses.add('Id IN (SELECT Movie__c FROM MovieGenre__c WHERE Genre__c IN :genreIds)');
        }

        String whereClause = whereClauses.isEmpty() ? '' : ' WHERE ' + String.join(whereClauses, ' AND ');
        return Database.countQuery('SELECT COUNT() FROM Movie__c' + whereClause);
    }

    /**
     * @description Fetches a movie by TMDB Id.
     * @param tmdbId TMDB id string.
     * @return Movie__c record or null.
     */
    public static Movie__c fetchByTmdbId(String tmdbId) {
        if (String.isBlank(tmdbId)) {
            return null;
        }
        List<Movie__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Movie__c WHERE TMDB_Id__c = :tmdbId LIMIT 1'
        );
        return sanitizeSingle(records);
    }

    /**
     * @description Fetches movies by Ids.
     * @param movieIds Set of Ids.
     * @return List of Movie__c records.
     */
    public static List<Movie__c> fetchByIds(Set<Id> movieIds) {
        if (movieIds == null || movieIds.isEmpty()) {
            return new List<Movie__c>();
        }
        List<Movie__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Movie__c WHERE Id IN :movieIds'
        );
        return sanitizeList(records);
    }

    private static String buildOrderBy(String sortValue) {
        if (String.isBlank(sortValue) || sortValue == 'releaseDate_desc') {
            return 'ORDER BY ReleaseDate__c DESC NULLS LAST';
        }
        if (sortValue == 'voteAverage_desc') {
            return 'ORDER BY VoteAverage__c DESC NULLS LAST';
        }
        if (sortValue == 'popularity_desc') {
            return 'ORDER BY Popularity__c DESC NULLS LAST';
        }
        throw new ValidationException('Invalid parameter: sort.', new Map<String, Object>{
            'param' => 'sort',
            'value' => sortValue,
            'allowed' => new List<String>{ 'releaseDate_desc', 'voteAverage_desc', 'popularity_desc' }
        });
    }

    private static Movie__c sanitizeSingle(List<Movie__c> records) {
        if (records == null || records.isEmpty()) {
            return null;
        }
        List<Movie__c> sanitized = (List<Movie__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
        return sanitized.isEmpty() ? null : sanitized[0];
    }

    private static List<Movie__c> sanitizeList(List<Movie__c> records) {
        if (records == null) {
            return new List<Movie__c>();
        }
        return (List<Movie__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
    }
}
