/**
 * @file FilmDAO
 * @description Centralized SOQL access for Film__c.
 * @layer DAO
 * @patterns DAO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class FilmDAO {
    private static final String BASE_FIELDS =
        'Id, Name, ExternalKey__c, PosterUrl__c, ReleaseYear__c, DurationMinutes__c';

    /**
     * @description Fetches a film by Salesforce Id.
     * @param filmId Film record Id.
     * @return Film__c record or null.
     * @throws ApiException When query fails.
     */
    public static Film__c fetchById(Id filmId) {
        if (filmId == null) {
            return null;
        }
        List<Film__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Film__c WHERE Id = :filmId LIMIT 1'
        );
        return sanitizeSingle(records);
    }

    /**
     * @description Fetches films by a set of Ids.
     * @param filmIds Set of film Ids.
     * @return List of Film__c records.
     * @throws ApiException When query fails.
     */
    public static List<Film__c> fetchByIds(Set<Id> filmIds) {
        if (filmIds == null || filmIds.isEmpty()) {
            return new List<Film__c>();
        }
        List<Film__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Film__c WHERE Id IN :filmIds'
        );
        return sanitizeList(records);
    }

    /**
     * @description Fetches a film by ExternalKey__c.
     * @param externalKey External key value.
     * @return Film__c record or null.
     * @throws ApiException When query fails.
     */
    public static Film__c fetchByExternalKey(String externalKey) {
        if (String.isBlank(externalKey)) {
            return null;
        }
        List<Film__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Film__c WHERE ExternalKey__c = :externalKey LIMIT 1'
        );
        return sanitizeSingle(records);
    }

    private static Film__c sanitizeSingle(List<Film__c> records) {
        if (records == null || records.isEmpty()) {
            return null;
        }
        List<Film__c> sanitized = (List<Film__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
        return sanitized.isEmpty() ? null : sanitized[0];
    }

    private static List<Film__c> sanitizeList(List<Film__c> records) {
        if (records == null) {
            return new List<Film__c>();
        }
        return (List<Film__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
    }
}
