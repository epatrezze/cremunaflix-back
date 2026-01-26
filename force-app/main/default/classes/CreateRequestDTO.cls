/**
 * @file CreateRequestDTO
 * @description Input payload for creating a request.
 * @layer DTO
 * @patterns DTO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class CreateRequestDTO {
    public String requesterName;
    public String requesterEmail;
    public String filmId;
    public String requestedTitle;
    public Integer requestedYear;
    public String notes;
    public String priority;
}
