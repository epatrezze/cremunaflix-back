/**
 * @file RequestMapper
 * @description Maps Request__c to RequestDTO.
 * @layer Mapper
 * @patterns Mapper
 * @author IA
 * @date 2026-01-25
 */
public with sharing class RequestMapper {
    /**
     * @description Converts a Request__c record into a RequestDTO.
     * @param requestRecord Request__c record.
     * @return RequestDTO instance.
     * @throws ApiException When mapping fails.
     */
    public static RequestDTO toDto(Request__c requestRecord) {
        if (requestRecord == null) {
            return null;
        }

        RequestDTO dto = new RequestDTO();
        dto.id = String.valueOf(requestRecord.Id);
        dto.status = requestRecord.Status__c;
        dto.requesterName = requestRecord.RequesterName__c;
        dto.requesterEmail = requestRecord.RequesterEmail__c;
        dto.filmId = FilmMapper.toFilmId(requestRecord.Film__r);
        dto.requestedTitle = requestRecord.RequestedTitle__c;
        dto.requestedYear = requestRecord.RequestedYear__c != null
            ? requestRecord.RequestedYear__c.intValue()
            : null;
        dto.notes = requestRecord.Notes__c;
        dto.createdAt = DateTimeUtil.formatIso(requestRecord.CreatedDate);
        return dto;
    }

    /**
     * @description Converts a list of Request__c records into RequestDTOs.
     * @param requests List of Request__c records.
     * @return List of RequestDTOs.
     * @throws ApiException When mapping fails.
     */
    public static List<RequestDTO> toDtos(List<Request__c> requests) {
        List<RequestDTO> results = new List<RequestDTO>();
        if (requests == null) {
            return results;
        }
        for (Request__c requestRecord : requests) {
            results.add(toDto(requestRecord));
        }
        return results;
    }
}
