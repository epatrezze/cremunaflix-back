/**
 * @file SessionMapper
 * @description Maps Session__c to SessionDTO.
 * @layer Mapper
 * @patterns Mapper
 * @author IA
 * @date 2026-01-25
 */
public with sharing class SessionMapper {
    /**
     * @description Converts a Session__c record into a SessionDTO.
     * @param sessionRecord Session__c record.
     * @return SessionDTO instance.
     * @throws ApiException When mapping fails.
     */
    public static SessionDTO toDto(Session__c sessionRecord) {
        if (sessionRecord == null) {
            return null;
        }

        SessionDTO dto = new SessionDTO();
        dto.id = String.valueOf(sessionRecord.Id);
        dto.filmId = FilmMapper.toFilmId(sessionRecord.Film__r);
        dto.filmName = FilmMapper.toFilmName(sessionRecord.Film__r);
        dto.startDateTime = DateTimeUtil.formatIso(sessionRecord.StartDateTime__c);
        dto.endDateTime = DateTimeUtil.formatIso(sessionRecord.EndDateTime__c);
        dto.status = sessionRecord.Status__c;
        dto.venue = sessionRecord.Venue__c;
        dto.notes = sessionRecord.Notes__c;
        dto.posterUrl = FilmMapper.toPosterUrl(sessionRecord.Film__r);
        dto.releaseYear = FilmMapper.toReleaseYear(sessionRecord.Film__r);
        dto.durationMinutes = FilmMapper.toDurationMinutes(sessionRecord.Film__r);
        return dto;
    }

    /**
     * @description Converts a list of Session__c records into SessionDTOs.
     * @param sessions List of Session__c records.
     * @return List of SessionDTOs.
     * @throws ApiException When mapping fails.
     */
    public static List<SessionDTO> toDtos(List<Session__c> sessions) {
        List<SessionDTO> results = new List<SessionDTO>();
        if (sessions == null) {
            return results;
        }
        for (Session__c sessionRecord : sessions) {
            results.add(toDto(sessionRecord));
        }
        return results;
    }
}
