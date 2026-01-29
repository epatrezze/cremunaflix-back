/**
 * @file PageInfoDTO
 * @description Pagination metadata for API v1 responses.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class PageInfoDTO {
    public Integer page;
    public Integer pageSize;
    public Integer totalItems;
    public Integer totalPages;
}
