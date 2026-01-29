/**
 * @file SessionDTO
 * @description Session payload for API v1 responses.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class SessionDTO {
    public String id;
    public String startDateTime;
    public String status;
    public MovieSummaryDTO movie;
}
