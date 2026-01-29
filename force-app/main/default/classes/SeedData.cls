/**
 * @file SeedData
 * @description Creates baseline data for manual API testing.
 * @layer Utility
 * @patterns Factory
 * @author epatrezze
 * @date 2026-01-29
 */
public without sharing class SeedData {
    public static void seedBasic() {
        Map<Integer, Genre__c> genres = upsertGenres();
        Map<String, Movie__c> movies = upsertMovies();
        upsertMovieGenres(movies, genres);
        Map<String, Contact> contacts = ensureContacts();
        ensureSessions(movies);
        ensureRequests(movies, contacts);
    }

    private static Map<Integer, Genre__c> upsertGenres() {
        List<Genre__c> toUpsert = new List<Genre__c>{
            new Genre__c(Name = 'Action', TMDB_GenreId__c = 28),
            new Genre__c(Name = 'Drama', TMDB_GenreId__c = 18),
            new Genre__c(Name = 'Sci-Fi', TMDB_GenreId__c = 878),
            new Genre__c(Name = 'Adventure', TMDB_GenreId__c = 12),
            new Genre__c(Name = 'Comedy', TMDB_GenreId__c = 35)
        };
        upsert toUpsert TMDB_GenreId__c;

        Set<Integer> ids = new Set<Integer>();
        for (Genre__c record : toUpsert) {
            ids.add((Integer) record.TMDB_GenreId__c);
        }
        List<Genre__c> rows = [
            SELECT Id, Name, TMDB_GenreId__c
            FROM Genre__c
            WHERE TMDB_GenreId__c IN :ids
        ];
        Map<Integer, Genre__c> result = new Map<Integer, Genre__c>();
        for (Genre__c record : rows) {
            result.put((Integer) record.TMDB_GenreId__c, record);
        }
        return result;
    }

    private static Map<String, Movie__c> upsertMovies() {
        List<Movie__c> toUpsert = new List<Movie__c>{
            new Movie__c(
                Name = 'Interstellar',
                Title__c = 'Interstellar',
                Status__c = 'EXHIBITED',
                ExternalSource__c = 'TMDB',
                TMDB_Id__c = '157336',
                Overview__c = 'A team travels through a wormhole to save humanity.',
                ReleaseDate__c = Date.newInstance(2014, 11, 7),
                RuntimeMinutes__c = 169,
                IMDB_Url__c = 'https://www.imdb.com/title/tt0816692/',
                PosterUrl__c = 'https://image.tmdb.org/t/p/w500/interstellar.jpg',
                BackdropUrl__c = 'https://image.tmdb.org/t/p/original/interstellar-bg.jpg',
                Popularity__c = 87.1234,
                VoteAverage__c = 8.65,
                VoteCount__c = 33000,
                OriginalTitle__c = 'Interstellar',
                OriginalLanguage__c = 'en',
                Adult__c = false,
                Certification__c = 'PG-13'
            ),
            new Movie__c(
                Name = 'The Matrix',
                Title__c = 'The Matrix',
                Status__c = 'EXHIBITED',
                ExternalSource__c = 'TMDB',
                TMDB_Id__c = '603',
                Overview__c = 'A hacker learns reality is a simulation.',
                ReleaseDate__c = Date.newInstance(1999, 3, 31),
                RuntimeMinutes__c = 136,
                IMDB_Url__c = 'https://www.imdb.com/title/tt0133093/',
                PosterUrl__c = 'https://image.tmdb.org/t/p/w500/matrix.jpg',
                BackdropUrl__c = 'https://image.tmdb.org/t/p/original/matrix-bg.jpg',
                Popularity__c = 80.4321,
                VoteAverage__c = 8.70,
                VoteCount__c = 25000,
                OriginalTitle__c = 'The Matrix',
                OriginalLanguage__c = 'en',
                Adult__c = false,
                Certification__c = 'R'
            ),
            new Movie__c(
                Name = 'Dune Part Two',
                Title__c = 'Dune: Part Two',
                Status__c = 'UPCOMING',
                ExternalSource__c = 'TMDB',
                TMDB_Id__c = '693134',
                Overview__c = 'Paul leads the Fremen against the conspirators.',
                ReleaseDate__c = Date.newInstance(2024, 3, 1),
                RuntimeMinutes__c = 166,
                IMDB_Url__c = 'https://www.imdb.com/title/tt15239678/',
                PosterUrl__c = 'https://image.tmdb.org/t/p/w500/dune2.jpg',
                BackdropUrl__c = 'https://image.tmdb.org/t/p/original/dune2-bg.jpg',
                Popularity__c = 95.1111,
                VoteAverage__c = 8.20,
                VoteCount__c = 15000,
                OriginalTitle__c = 'Dune: Part Two',
                OriginalLanguage__c = 'en',
                Adult__c = false,
                Certification__c = 'PG-13'
            ),
            new Movie__c(
                Name = 'Indie Request',
                Title__c = 'Indie Request',
                Status__c = 'REQUESTED',
                ExternalSource__c = 'MANUAL',
                TMDB_Id__c = 'MANUAL-001',
                Overview__c = 'A small town story.',
                ReleaseDate__c = Date.newInstance(2023, 6, 15),
                RuntimeMinutes__c = 102,
                Popularity__c = 12.5,
                VoteAverage__c = 7.10,
                VoteCount__c = 1200,
                OriginalTitle__c = 'Indie Request',
                OriginalLanguage__c = 'en',
                Adult__c = false,
                Certification__c = 'PG'
            )
        };
        upsert toUpsert TMDB_Id__c;

        Set<String> ids = new Set<String>();
        for (Movie__c record : toUpsert) {
            ids.add(record.TMDB_Id__c);
        }
        List<Movie__c> rows = [
            SELECT Id, TMDB_Id__c, Title__c
            FROM Movie__c
            WHERE TMDB_Id__c IN :ids
        ];
        Map<String, Movie__c> result = new Map<String, Movie__c>();
        for (Movie__c record : rows) {
            result.put(record.TMDB_Id__c, record);
        }
        return result;
    }

    private static void upsertMovieGenres(Map<String, Movie__c> movies, Map<Integer, Genre__c> genres) {
        if (movies.isEmpty() || genres.isEmpty()) {
            return;
        }

        Map<String, Id> movieIds = new Map<String, Id>{
            'INTERSTELLAR' => movies.get('157336').Id,
            'MATRIX' => movies.get('603').Id,
            'DUNE2' => movies.get('693134').Id,
            'INDIE' => movies.get('MANUAL-001').Id
        };

        Map<String, Id> genreIds = new Map<String, Id>{
            'ACTION' => genres.get(28).Id,
            'DRAMA' => genres.get(18).Id,
            'SCIFI' => genres.get(878).Id,
            'ADVENTURE' => genres.get(12).Id
        };

        List<MovieGenre__c> desired = new List<MovieGenre__c>{
            buildMovieGenre('Interstellar - Sci-Fi', movieIds.get('INTERSTELLAR'), genreIds.get('SCIFI')),
            buildMovieGenre('Interstellar - Adventure', movieIds.get('INTERSTELLAR'), genreIds.get('ADVENTURE')),
            buildMovieGenre('Interstellar - Drama', movieIds.get('INTERSTELLAR'), genreIds.get('DRAMA')),
            buildMovieGenre('The Matrix - Action', movieIds.get('MATRIX'), genreIds.get('ACTION')),
            buildMovieGenre('The Matrix - Sci-Fi', movieIds.get('MATRIX'), genreIds.get('SCIFI')),
            buildMovieGenre('Dune Part Two - Sci-Fi', movieIds.get('DUNE2'), genreIds.get('SCIFI')),
            buildMovieGenre('Dune Part Two - Adventure', movieIds.get('DUNE2'), genreIds.get('ADVENTURE')),
            buildMovieGenre('Indie Request - Drama', movieIds.get('INDIE'), genreIds.get('DRAMA'))
        };

        Set<String> keys = new Set<String>();
        for (MovieGenre__c record : desired) {
            keys.add(record.MovieGenreKey__c);
        }
        Set<String> existingKeys = new Set<String>();
        for (MovieGenre__c row : [
            SELECT MovieGenreKey__c
            FROM MovieGenre__c
            WHERE MovieGenreKey__c IN :keys
        ]) {
            existingKeys.add(row.MovieGenreKey__c);
        }

        List<MovieGenre__c> toInsert = new List<MovieGenre__c>();
        for (MovieGenre__c record : desired) {
            if (!existingKeys.contains(record.MovieGenreKey__c)) {
                toInsert.add(record);
            }
        }
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }

    private static MovieGenre__c buildMovieGenre(String name, Id movieId, Id genreId) {
        return new MovieGenre__c(
            Name = name,
            Movie__c = movieId,
            Genre__c = genreId,
            MovieGenreKey__c = movieId + '-' + genreId
        );
    }

    private static Map<String, Contact> ensureContacts() {
        List<String> emails = new List<String>{
            'ana.silva@example.com',
            'bruno.costa@example.com'
        };
        Map<String, Contact> existing = new Map<String, Contact>();
        for (Contact row : [
            SELECT Id, Email, FirstName, LastName
            FROM Contact
            WHERE Email IN :emails
        ]) {
            existing.put(row.Email, row);
        }

        List<Contact> toInsert = new List<Contact>();
        if (!existing.containsKey('ana.silva@example.com')) {
            toInsert.add(new Contact(FirstName = 'Ana', LastName = 'Silva', Email = 'ana.silva@example.com'));
        }
        if (!existing.containsKey('bruno.costa@example.com')) {
            toInsert.add(new Contact(FirstName = 'Bruno', LastName = 'Costa', Email = 'bruno.costa@example.com'));
        }
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }

        Map<String, Contact> result = new Map<String, Contact>();
        for (Contact row : [
            SELECT Id, Email, FirstName, LastName
            FROM Contact
            WHERE Email IN :emails
        ]) {
            result.put(row.Email, row);
        }
        return result;
    }

    private static void ensureSessions(Map<String, Movie__c> movies) {
        if (movies.isEmpty()) {
            return;
        }

        Datetime upcomingStart = DateTime.newInstance(Date.today().addDays(7), Time.newInstance(20, 0, 0, 0));
        Datetime pastStart = DateTime.newInstance(Date.today().addDays(-14), Time.newInstance(20, 0, 0, 0));

        List<Session__c> desired = new List<Session__c>{
            new Session__c(
                Name = 'Interstellar Screening (Upcoming)',
                Movie__c = movies.get('157336').Id,
                StartDateTime__c = upcomingStart,
                EndDateTime__c = upcomingStart.addHours(2),
                Status__c = 'UPCOMING',
                SessionType__c = 'SCREENING',
                Location__c = 'Main Hall'
            ),
            new Session__c(
                Name = 'Matrix Retro Night (Past)',
                Movie__c = movies.get('603').Id,
                StartDateTime__c = pastStart,
                EndDateTime__c = pastStart.addHours(2),
                Status__c = 'DONE',
                SessionType__c = 'SPECIAL',
                Location__c = 'Auditorium 2'
            )
        };

        Set<String> names = new Set<String>();
        for (Session__c record : desired) {
            names.add(record.Name);
        }
        Set<String> existing = new Set<String>();
        for (Session__c row : [
            SELECT Name
            FROM Session__c
            WHERE Name IN :names
        ]) {
            existing.add(row.Name);
        }

        List<Session__c> toInsert = new List<Session__c>();
        for (Session__c record : desired) {
            if (!existing.contains(record.Name)) {
                toInsert.add(record);
            }
        }
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }

    private static void ensureRequests(Map<String, Movie__c> movies, Map<String, Contact> contacts) {
        if (movies.isEmpty() || contacts.isEmpty()) {
            return;
        }

        Contact ana = contacts.get('ana.silva@example.com');
        Contact bruno = contacts.get('bruno.costa@example.com');

        List<MovieRequest__c> desired = new List<MovieRequest__c>{
            new MovieRequest__c(
                Name = 'Request Matrix',
                RequestedBy__c = ana.Id,
                Title__c = 'The Matrix',
                Status__c = 'PENDING',
                RequesterName__c = 'Ana Silva',
                RequesterEmail__c = 'ana.silva@example.com',
                Source__c = 'GUEST',
                TMDB_Id__c = '603',
                PosterUrl__c = 'https://image.tmdb.org/t/p/w500/matrix.jpg',
                Notes__c = 'Quero ver em 4K.',
                Movie__c = movies.get('603').Id
            ),
            new MovieRequest__c(
                Name = 'Request Indie',
                RequestedBy__c = bruno.Id,
                Title__c = 'Indie Request',
                Status__c = 'PENDING',
                RequesterName__c = 'Bruno Costa',
                RequesterEmail__c = 'bruno.costa@example.com',
                Source__c = 'AUTHENTICATED',
                TMDB_Id__c = 'MANUAL-001',
                Notes__c = 'Filme sugerido pela comunidade.',
                Movie__c = movies.get('MANUAL-001').Id
            )
        };

        Set<String> names = new Set<String>();
        for (MovieRequest__c record : desired) {
            names.add(record.Name);
        }
        Set<String> existing = new Set<String>();
        for (MovieRequest__c row : [
            SELECT Name
            FROM MovieRequest__c
            WHERE Name IN :names
        ]) {
            existing.add(row.Name);
        }

        List<MovieRequest__c> toInsert = new List<MovieRequest__c>();
        for (MovieRequest__c record : desired) {
            if (!existing.contains(record.Name)) {
                toInsert.add(record);
            }
        }
        if (!toInsert.isEmpty()) {
            insert toInsert;
        }
    }
}
