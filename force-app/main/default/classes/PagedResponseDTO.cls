/**
 * @file PagedResponseDTO
 * @description Wrapper for paginated list responses.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class PagedResponseDTO {
    public List<Object> items;
    public PageInfoDTO pageInfo;
}
