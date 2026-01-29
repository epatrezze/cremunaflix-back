/**
 * @file MovieDTO
 * @description Movie payload for API v1 responses.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class MovieDTO {
    public String id;
    public String tmdbId;
    public String title;
    public String overview;
    public Date releaseDate;
    public Integer releaseYear;
    public Integer runtimeMinutes;
    public String imdbUrl;
    public MovieImagesDTO images;
    public List<GenreDTO> genres;
    public MovieMetricsDTO metrics;
    public String status;
}
