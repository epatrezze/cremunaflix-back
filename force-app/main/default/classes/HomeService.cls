/**
 * @file HomeService
 * @description Composes home endpoint payloads for API v1.
 * @layer Service
 * @patterns Facade
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class HomeService {
    private static final Integer DEFAULT_LIMIT = 5;

    /**
     * @description Returns HomeDTO payload.
     * @return HomeDTO instance.
     */
    public HomeDTO getHome() {
        HomeDTO dto = new HomeDTO();

        HomeHeroDTO hero = new HomeHeroDTO();
        hero.title = 'Ultimas sessoes';
        hero.items = new SessionService().getRecentSessions(DEFAULT_LIMIT);
        dto.hero = hero;

        dto.lastExhibited = new SessionService().getLastExhibitedMovies(DEFAULT_LIMIT);
        dto.mostRequested = new RequestService().getMostRequestedMovies(DEFAULT_LIMIT);
        return dto;
    }
}
