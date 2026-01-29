/**
 * @file MovieMapper
 * @description Maps Movie__c records to DTOs.
 * @layer Mapper
 * @patterns Mapper
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class MovieMapper {
    /**
     * @description Maps Movie__c to MovieDTO.
     * @param record Movie__c record.
     * @return MovieDTO instance.
     */
    public static MovieDTO toDto(Movie__c record) {
        if (record == null) {
            return null;
        }

        MovieDTO dto = new MovieDTO();
        dto.id = String.valueOf(record.Id);
        dto.tmdbId = record.TMDB_Id__c;
        dto.title = record.Title__c;
        dto.overview = record.Overview__c;
        dto.releaseDate = record.ReleaseDate__c;
        dto.releaseYear = record.ReleaseYear__c != null ? record.ReleaseYear__c.intValue() : null;
        dto.runtimeMinutes = record.RuntimeMinutes__c != null ? record.RuntimeMinutes__c.intValue() : null;
        dto.imdbUrl = record.IMDB_Url__c;
        dto.status = record.Status__c;

        MovieImagesDTO images = new MovieImagesDTO();
        images.posterUrl = record.PosterUrl__c;
        images.backdropUrl = record.BackdropUrl__c;
        dto.images = images;

        MovieMetricsDTO metrics = new MovieMetricsDTO();
        metrics.popularity = record.Popularity__c;
        metrics.voteAverage = record.VoteAverage__c;
        metrics.voteCount = record.VoteCount__c != null ? record.VoteCount__c.intValue() : null;
        dto.metrics = metrics;

        dto.genres = toGenres(record.MovieGenres__r);
        return dto;
    }

    /**
     * @description Maps Movie__c to MovieSummaryDTO.
     * @param record Movie__c record.
     * @return MovieSummaryDTO instance.
     */
    public static MovieSummaryDTO toSummary(Movie__c record) {
        if (record == null) {
            return null;
        }
        MovieSummaryDTO dto = new MovieSummaryDTO();
        dto.id = String.valueOf(record.Id);
        dto.tmdbId = record.TMDB_Id__c;
        dto.title = record.Title__c;
        dto.releaseYear = record.ReleaseYear__c != null ? record.ReleaseYear__c.intValue() : null;
        dto.posterUrl = record.PosterUrl__c;
        dto.status = record.Status__c;
        return dto;
    }

    private static List<GenreDTO> toGenres(List<MovieGenre__c> movieGenres) {
        List<GenreDTO> results = new List<GenreDTO>();
        if (movieGenres == null) {
            return results;
        }
        for (MovieGenre__c link : movieGenres) {
            if (link == null || link.Genre__r == null) {
                continue;
            }
            GenreDTO dto = new GenreDTO();
            dto.id = String.valueOf(link.Genre__r.Id);
            dto.tmdbId = link.Genre__r.TMDB_GenreId__c != null
                ? String.valueOf(link.Genre__r.TMDB_GenreId__c)
                : null;
            dto.name = link.Genre__r.Name;
            results.add(dto);
        }
        return results;
    }
}
