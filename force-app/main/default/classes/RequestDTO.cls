/**
 * @file RequestDTO
 * @description Movie request payload for API v1 responses.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class RequestDTO {
    public String id;
    public String status;
    public String requestedAt;
    public String requestedBy;
    public String tmdbId;
    public String title;
    public String posterUrl;
    public MovieSummaryDTO movie;
}
