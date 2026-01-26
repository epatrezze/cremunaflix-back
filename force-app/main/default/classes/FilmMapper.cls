/**
 * @file FilmMapper
 * @description Maps Film__c fields to DTO-friendly values.
 * @layer Mapper
 * @patterns Mapper
 * @author IA
 * @date 2026-01-25
 */
public with sharing class FilmMapper {
    /**
     * @description Extracts a film identifier for API responses.
     * @param filmRecord Film__c record.
     * @return Film identifier string.
     * @throws ApiException When mapping fails.
     */
    public static String toFilmId(Film__c filmRecord) {
        if (filmRecord == null) {
            return null;
        }
        return String.isBlank(filmRecord.ExternalKey__c)
            ? String.valueOf(filmRecord.Id)
            : filmRecord.ExternalKey__c;
    }

    /**
     * @description Extracts the film name.
     * @param filmRecord Film__c record.
     * @return Film name.
     * @throws ApiException When mapping fails.
     */
    public static String toFilmName(Film__c filmRecord) {
        return filmRecord != null ? filmRecord.Name : null;
    }

    /**
     * @description Extracts poster URL.
     * @param filmRecord Film__c record.
     * @return Poster URL.
     * @throws ApiException When mapping fails.
     */
    public static String toPosterUrl(Film__c filmRecord) {
        return filmRecord != null ? filmRecord.PosterUrl__c : null;
    }

    /**
     * @description Extracts release year.
     * @param filmRecord Film__c record.
     * @return Release year.
     * @throws ApiException When mapping fails.
     */
    public static Integer toReleaseYear(Film__c filmRecord) {
        if (filmRecord == null || filmRecord.ReleaseYear__c == null) {
            return null;
        }
        return filmRecord.ReleaseYear__c.intValue();
    }

    /**
     * @description Extracts duration in minutes.
     * @param filmRecord Film__c record.
     * @return Duration in minutes.
     * @throws ApiException When mapping fails.
     */
    public static Integer toDurationMinutes(Film__c filmRecord) {
        if (filmRecord == null || filmRecord.DurationMinutes__c == null) {
            return null;
        }
        return filmRecord.DurationMinutes__c.intValue();
    }
}
