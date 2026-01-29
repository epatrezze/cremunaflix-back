/**
 * @file SessionDAO
 * @description SOQL access for Session__c.
 * @layer DAO
 * @patterns DAO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class SessionDAO {
    private static final String BASE_FIELDS =
        'Id, StartDateTime__c, Status__c, Movie__r.Id, Movie__r.TMDB_Id__c, Movie__r.Title__c, ' +
        'Movie__r.ReleaseYear__c, Movie__r.PosterUrl__c, Movie__r.Status__c';

    /**
     * @description Fetches upcoming sessions.
     * @param limitSize Max number of records.
     * @param offsetValue Offset for pagination.
     * @return List of Session__c records.
     */
    public static List<Session__c> fetchUpcoming(Integer limitSize, Integer offsetValue) {
        Datetime nowValue = System.now();
        List<Session__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Session__c ' +
            'WHERE StartDateTime__c >= :nowValue ' +
            'ORDER BY StartDateTime__c ASC ' +
            'LIMIT :limitSize OFFSET :offsetValue'
        );
        return sanitizeList(records);
    }

    /**
     * @description Counts upcoming sessions.
     * @return Total count.
     */
    public static Integer countUpcoming() {
        Datetime nowValue = System.now();
        return Database.countQuery(
            'SELECT COUNT() FROM Session__c WHERE StartDateTime__c >= :nowValue'
        );
    }

    /**
     * @description Fetches past sessions.
     * @param limitSize Max number of records.
     * @param offsetValue Offset for pagination.
     * @return List of Session__c records.
     */
    public static List<Session__c> fetchPast(Integer limitSize, Integer offsetValue) {
        Datetime nowValue = System.now();
        List<Session__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Session__c ' +
            'WHERE StartDateTime__c < :nowValue ' +
            'ORDER BY StartDateTime__c DESC ' +
            'LIMIT :limitSize OFFSET :offsetValue'
        );
        return sanitizeList(records);
    }

    /**
     * @description Counts past sessions.
     * @return Total count.
     */
    public static Integer countPast() {
        Datetime nowValue = System.now();
        return Database.countQuery(
            'SELECT COUNT() FROM Session__c WHERE StartDateTime__c < :nowValue'
        );
    }

    /**
     * @description Fetches recent sessions for home.
     * @param limitSize Max number of records.
     * @return List of Session__c records.
     */
    public static List<Session__c> fetchRecent(Integer limitSize) {
        List<Session__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Session__c ' +
            'ORDER BY StartDateTime__c DESC ' +
            'LIMIT :limitSize'
        );
        return sanitizeList(records);
    }

    private static List<Session__c> sanitizeList(List<Session__c> records) {
        if (records == null) {
            return new List<Session__c>();
        }
        return (List<Session__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
    }
}
