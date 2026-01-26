/**
 * @file SessionDTO
 * @description Session data transfer object for API responses.
 * @layer DTO
 * @patterns DTO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class SessionDTO {
    public String id;
    public String filmId;
    public String filmName;
    public String startDateTime;
    public String endDateTime;
    public String status;
    public String venue;
    public String notes;
    public String posterUrl;
    public Integer releaseYear;
    public Integer durationMinutes;
}
