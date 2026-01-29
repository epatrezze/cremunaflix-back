/**
 * @file RequestDAO
 * @description SOQL and DML access for MovieRequest__c.
 * @layer DAO
 * @patterns DAO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class RequestDAO {
    private static final String BASE_FIELDS =
        'Id, Status__c, CreatedDate, RequestedBy__r.Name, TMDB_Id__c, Title__c, PosterUrl__c, ' +
        'Movie__r.Id, Movie__r.TMDB_Id__c, Movie__r.Title__c, Movie__r.ReleaseYear__c, ' +
        'Movie__r.PosterUrl__c, Movie__r.Status__c';

    /**
     * @description Fetches requests with pagination.
     * @param offsetValue Offset for pagination.
     * @param limitSize Max number of records.
     * @param sortValue Sort value.
     * @return List of MovieRequest__c records.
     */
    public static List<MovieRequest__c> fetchRequests(Integer offsetValue, Integer limitSize, String sortValue) {
        String orderByClause = buildOrderBy(sortValue);
        List<MovieRequest__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM MovieRequest__c ' +
            'ORDER BY ' + orderByClause + ' ' +
            'LIMIT :limitSize OFFSET :offsetValue'
        );
        return sanitizeList(records);
    }

    /**
     * @description Counts total requests.
     * @return Total count.
     */
    public static Integer countRequests() {
        return Database.countQuery('SELECT COUNT() FROM MovieRequest__c');
    }

    /**
     * @description Inserts a movie request record with CRUD/FLS enforcement.
     * @param record MovieRequest__c record to insert.
     * @return Inserted record Id.
     */
    public static Id insertRequest(MovieRequest__c record) {
        List<SObject> creatable = Security.stripInaccessible(
            AccessType.CREATABLE,
            new List<SObject>{ record }
        ).getRecords();
        if (creatable.isEmpty()) {
            throw new ApiException(403, 'FORBIDDEN', 'Missing create permission.', null);
        }
        Database.insert(creatable[0], false);
        return ((MovieRequest__c) creatable[0]).Id;
    }

    /**
     * @description Fetches requests by id.
     * @param requestId Request Id.
     * @return MovieRequest__c record or null.
     */
    public static MovieRequest__c fetchById(Id requestId) {
        if (requestId == null) {
            return null;
        }
        List<MovieRequest__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM MovieRequest__c WHERE Id = :requestId LIMIT 1'
        );
        return sanitizeSingle(records);
    }

    /**
     * @description Returns most requested Movie__c Ids.
     * @param limitSize Max number of records.
     * @return List of Movie__c Ids.
     */
    public static List<Id> fetchMostRequestedMovieIds(Integer limitSize) {
        List<AggregateResult> results = [
            SELECT Movie__c movieId, COUNT(Id) total
            FROM MovieRequest__c
            WHERE Movie__c != null
            GROUP BY Movie__c
            ORDER BY COUNT(Id) DESC
            LIMIT :limitSize
        ];
        List<Id> ids = new List<Id>();
        for (AggregateResult row : results) {
            ids.add((Id) row.get('movieId'));
        }
        return ids;
    }

    private static String buildOrderBy(String sortValue) {
        if (String.isBlank(sortValue) || sortValue == 'requestedAt_desc') {
            return 'CreatedDate DESC';
        }
        if (sortValue == 'requestedAt_asc') {
            return 'CreatedDate ASC';
        }
        throw new ValidationException('Invalid parameter: sort.', new Map<String, Object>{
            'param' => 'sort',
            'value' => sortValue,
            'allowed' => new List<String>{ 'requestedAt_desc', 'requestedAt_asc' }
        });
    }

    private static MovieRequest__c sanitizeSingle(List<MovieRequest__c> records) {
        if (records == null || records.isEmpty()) {
            return null;
        }
        List<MovieRequest__c> sanitized = (List<MovieRequest__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
        return sanitized.isEmpty() ? null : sanitized[0];
    }

    private static List<MovieRequest__c> sanitizeList(List<MovieRequest__c> records) {
        if (records == null) {
            return new List<MovieRequest__c>();
        }
        return (List<MovieRequest__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
    }
}
