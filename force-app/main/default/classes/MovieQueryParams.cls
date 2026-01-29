/**
 * @file MovieQueryParams
 * @description Query parameters for movie searches.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class MovieQueryParams {
    public String query;
    public Integer year;
    public String status;
    public Set<Id> genreIds;
    public String sortValue;
}
