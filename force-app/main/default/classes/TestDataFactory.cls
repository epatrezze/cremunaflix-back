/**
 * @file TestDataFactory
 * @description Test data builders for Cremunaflix API tests.
 * @layer Test
 * @patterns Factory
 * @author epatrezze
 * @date 2026-01-27
 */
@IsTest
public class TestDataFactory {
    public static Contact createContact(String email) {
        Contact contact = new Contact(
            LastName = 'Requester',
            Email = email
        );
        insert contact;
        return contact;
    }

    public static Movie__c createMovie(String title, String tmdbId, String status) {
        Movie__c movie = new Movie__c(
            Name = title,
            Title__c = title,
            TMDB_Id__c = tmdbId,
            Status__c = status,
            ExternalSource__c = 'TMDB',
            ReleaseDate__c = Date.today().addYears(-1),
            PosterUrl__c = 'https://example.com/poster.jpg',
            BackdropUrl__c = 'https://example.com/backdrop.jpg',
            VoteAverage__c = 7.5,
            Popularity__c = 123.45
        );
        insert movie;
        return movie;
    }

    public static Genre__c createGenre(Integer tmdbId, String name) {
        Genre__c genre = new Genre__c(
            Name = name,
            TMDB_GenreId__c = tmdbId
        );
        insert genre;
        return genre;
    }

    public static MovieGenre__c createMovieGenre(Movie__c movie, Genre__c genre) {
        MovieGenre__c link = new MovieGenre__c(
            Name = movie.Title__c + '-' + genre.Name,
            Movie__c = movie.Id,
            Genre__c = genre.Id,
            MovieGenreKey__c = movie.Id + '-' + genre.Id
        );
        insert link;
        return link;
    }

    public static Session__c createSession(Movie__c movie, Datetime startTime, String status) {
        Session__c sessionRecord = new Session__c(
            Name = 'Session ' + startTime.getTime(),
            Movie__c = movie.Id,
            StartDateTime__c = startTime,
            Status__c = status,
            SessionType__c = 'SCREENING'
        );
        insert sessionRecord;
        return sessionRecord;
    }

    public static MovieRequest__c createRequest(Contact contact, Movie__c movie, String title, String tmdbId) {
        MovieRequest__c requestRecord = new MovieRequest__c(
            Name = 'Request ' + title,
            RequestedBy__c = contact.Id,
            Title__c = title,
            TMDB_Id__c = tmdbId,
            PosterUrl__c = 'https://example.com/poster.jpg',
            Status__c = 'PENDING'
        );
        if (movie != null) {
            requestRecord.Movie__c = movie.Id;
        }
        insert requestRecord;
        return requestRecord;
    }
}
