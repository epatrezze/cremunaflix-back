/**
 * @file SessionDAO
 * @description Centralized SOQL access for Session__c.
 * @layer DAO
 * @patterns DAO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class SessionDAO {
    private static final String BASE_FIELDS =
        'Id, StartDateTime__c, EndDateTime__c, Status__c, Venue__c, Notes__c, ' +
        'Film__r.Id, Film__r.Name, Film__r.ExternalKey__c, Film__r.PosterUrl__c, ' +
        'Film__r.ReleaseYear__c, Film__r.DurationMinutes__c';

    /**
     * @description Fetches upcoming sessions with pagination.
     * @param limitSize Max number of records.
     * @param offsetValue Offset for pagination.
     * @return List of Session__c records.
     * @throws ApiException When query fails.
     */
    public static List<Session__c> fetchUpcoming(Integer limitSize, Integer offsetValue) {
        Datetime nowValue = System.now();
        List<Session__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' ' +
            'FROM Session__c ' +
            'WHERE StartDateTime__c >= :nowValue ' +
            'ORDER BY StartDateTime__c ASC ' +
            'LIMIT :limitSize OFFSET :offsetValue'
        );
        return sanitizeList(records);
    }

    /**
     * @description Fetches upcoming sessions (legacy signature).
     * @param limitSize Max number of records.
     * @return List of Session__c records.
     * @throws ApiException When query fails.
     */
    public static List<Session__c> fetchUpcoming(Integer limitSize) {
        return fetchUpcoming(limitSize, 0);
    }

    /**
     * @description Counts upcoming sessions.
     * @param none
     * @return Total count.
     * @throws ApiException When query fails.
     */
    public static Integer countUpcoming() {
        Datetime nowValue = System.now();
        return Database.countQuery(
            'SELECT COUNT() FROM Session__c WHERE StartDateTime__c >= :nowValue'
        );
    }

    /**
     * @description Fetches past sessions within a range with pagination.
     * @param fromDt Start datetime.
     * @param toDt End datetime.
     * @param limitSize Max number of records.
     * @param offsetValue Offset for pagination.
     * @return List of Session__c records.
     * @throws ApiException When query fails.
     */
    public static List<Session__c> fetchPast(Datetime fromDt, Datetime toDt, Integer limitSize, Integer offsetValue) {
        List<Session__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' ' +
            'FROM Session__c ' +
            'WHERE StartDateTime__c >= :fromDt AND StartDateTime__c <= :toDt ' +
            'ORDER BY StartDateTime__c DESC ' +
            'LIMIT :limitSize OFFSET :offsetValue'
        );
        return sanitizeList(records);
    }

    /**
     * @description Fetches past sessions (legacy signature).
     * @param fromDt Start datetime.
     * @param toDt End datetime.
     * @param limitSize Max number of records.
     * @return List of Session__c records.
     * @throws ApiException When query fails.
     */
    public static List<Session__c> fetchPast(Datetime fromDt, Datetime toDt, Integer limitSize) {
        return fetchPast(fromDt, toDt, limitSize, 0);
    }

    /**
     * @description Counts past sessions in a range.
     * @param fromDt Start datetime.
     * @param toDt End datetime.
     * @return Total count.
     * @throws ApiException When query fails.
     */
    public static Integer countPast(Datetime fromDt, Datetime toDt) {
        return Database.countQuery(
            'SELECT COUNT() FROM Session__c WHERE StartDateTime__c >= :fromDt AND StartDateTime__c <= :toDt'
        );
    }

    private static List<Session__c> sanitizeList(List<Session__c> records) {
        if (records == null) {
            return new List<Session__c>();
        }
        return (List<Session__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
    }
}
