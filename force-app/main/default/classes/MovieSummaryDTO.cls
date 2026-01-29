/**
 * @file MovieSummaryDTO
 * @description Summary payload for movies.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class MovieSummaryDTO {
    public String id;
    public String tmdbId;
    public String title;
    public Integer releaseYear;
    public String posterUrl;
    public String status;
}
