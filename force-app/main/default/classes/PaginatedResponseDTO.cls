/**
 * @file PaginatedResponseDTO
 * @description Wrapper for paginated list responses.
 * @layer DTO
 * @patterns DTO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class PaginatedResponseDTO {
    public List<Object> items;
    public Integer page;
    public Integer pageSize;
    public Integer total;
}
