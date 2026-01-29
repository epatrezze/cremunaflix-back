/**
 * @file HomeDTO
 * @description Home endpoint payload.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class HomeDTO {
    public HomeHeroDTO hero;
    public List<MovieSummaryDTO> lastExhibited;
    public List<MovieSummaryDTO> mostRequested;
}
