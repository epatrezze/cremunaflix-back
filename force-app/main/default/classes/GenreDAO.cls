/**
 * @file GenreDAO
 * @description SOQL access for Genre__c.
 * @layer DAO
 * @patterns DAO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class GenreDAO {
    /**
     * @description Resolves genre Ids from a parameter (TMDB id or Salesforce Id).
     * @param rawGenreId Genre id parameter.
     * @return Set of Genre__c Ids.
     */
    public static Set<Id> resolveGenreIds(String rawGenreId) {
        if (String.isBlank(rawGenreId)) {
            return new Set<Id>();
        }

        String trimmed = rawGenreId.trim();
        if (isValidId(trimmed)) {
            return new Set<Id>{ (Id) trimmed };
        }

        Integer tmdbValue;
        try {
            tmdbValue = Integer.valueOf(trimmed);
        } catch (Exception ex) {
            throw new ValidationException('Invalid parameter: genreId.', new Map<String, Object>{
                'param' => 'genreId',
                'value' => trimmed,
                'reason' => 'expected Salesforce Id or TMDB numeric id'
            });
        }

        List<Genre__c> records = [
            SELECT Id FROM Genre__c WHERE TMDB_GenreId__c = :tmdbValue
        ];
        Set<Id> ids = new Set<Id>();
        for (Genre__c record : records) {
            ids.add(record.Id);
        }
        return ids;
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
