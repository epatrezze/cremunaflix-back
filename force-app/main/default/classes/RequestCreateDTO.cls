/**
 * @file RequestCreateDTO
 * @description Input payload for creating movie requests.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class RequestCreateDTO {
    public String tmdbId;
    public String title;
    public String posterUrl;
    public String notes;
    public String requestedById;
}
