/**
 * @file RequestDTO
 * @description Request data transfer object for API responses.
 * @layer DTO
 * @patterns DTO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class RequestDTO {
    public String id;
    public String status;
    public String requesterName;
    public String requesterEmail;
    public String filmId;
    public String requestedTitle;
    public Integer requestedYear;
    public String notes;
    public String createdAt;
}
