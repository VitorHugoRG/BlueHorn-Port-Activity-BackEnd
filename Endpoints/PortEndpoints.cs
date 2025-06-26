using Dapper;
using PortActivityAPI.Data;
using PortActivityAPI.Models;

namespace PortActivityAPI.Endpoints
{
    public static class PortEndpoints
    {
        public static void MapPortEndpoints(this WebApplication app)
        {

            app.MapGet("/api/activity", async (
     string? portCode,
     string? countryCode,
     string? cargoType,
     DateTime? startDate,
     DateTime? endDate,
     string? groupBy,
     string? orderBy,
     string? sortDirection,
     DapperContext context) =>
            {
                var safePortCode = portCode ?? "0";
                var safeCountryCode = countryCode ?? "";
                var safeCargoType = cargoType ?? "";
                var safeStartDate = startDate ?? new DateTime(1990, 1, 1);
                var safeEndDate = endDate ?? new DateTime(3000, 1, 1);
                var safeGroupBy = groupBy ?? "";
                var safeOrderBy = orderBy ?? "date";

                var safeSortDirection = (sortDirection ?? "desc").ToLower() == "asc" ? "ASC" : "DESC";

                string orderClause = safeOrderBy switch
                {
                    "importVolume" => $"importVolume {safeSortDirection}",
                    "exportVolume" => $"exportVolume {safeSortDirection}",
                    "totalVolume" => $"(importVolume + exportVolume) {safeSortDirection}",
                    _ => $"date {safeSortDirection}"
                };

                string query;

                if (safeGroupBy == "port")
                {
                    query = $@"
            SELECT 
                portname,
                countryname,
                cargotype,
                MIN(date) AS date,
                SUM(importvolume) AS importVolume,
                SUM(exportvolume) AS exportVolume
            FROM logistica.vw_daily_activity_
            WHERE (@portCode = '0' OR portcode::text = @portCode)
              AND (@countryCode = '' OR countrycode = @countryCode)
              AND (@cargoType = '' OR cargotype = @cargoType)
              AND date >= @startDate
              AND date <= @endDate
            GROUP BY portname, countryname, cargotype
            ORDER BY {orderClause}
            LIMIT 100;
        ";
                }
                else
                {
                    query = $@"
            SELECT * FROM logistica.vw_daily_activity_
            WHERE (@portCode = '0' OR portcode::text = @portCode)
              AND (@countryCode = '' OR countrycode = @countryCode)
              AND (@cargoType = '' OR cargotype = @cargoType)
              AND date >= @startDate
              AND date <= @endDate
            ORDER BY {orderClause}
            LIMIT 100;
        ";
                }

                using var connection = context.CreateConnection();
                var result = await connection.QueryAsync<DailyActivityModel>(query, new
                {
                    portCode = safePortCode,
                    countryCode = safeCountryCode,
                    cargoType = safeCargoType,
                    startDate = safeStartDate,
                    endDate = safeEndDate
                });

                return Results.Ok(result);
            });


            app.MapGet("/api/ports", async (string? search, DapperContext context) =>
            {
                var query = @"
                    SELECT DISTINCT port_id AS PortCode, name AS PortName 
                    FROM logistica.porto
                    WHERE (
                      @search IS NULL 
                      OR name ILIKE '%' || @search || '%'
                      OR CAST(port_id AS TEXT) ILIKE '%' || @search || '%'
                    )
                    ORDER BY name
                    LIMIT 10;
                ";

                using var connection = context.CreateConnection();
                var result = await connection.QueryAsync<PortBasic>(query, new { search });

                return Results.Ok(result);
            });


            app.MapGet("/api/countries", async (string? search, DapperContext context) =>
            {
                var query = @"
                    SELECT DISTINCT iso3 AS CountryCode, name AS CountryName
                    FROM logistica.pais
                    WHERE (@search IS NULL OR name ILIKE '%' || @search || '%' OR iso3 ILIKE '%' || @search || '%')
                    ORDER BY name
                    LIMIT 10;
                ";

                using var connection = context.CreateConnection();
                var result = await connection.QueryAsync<CountryBasic>(query, new { search });

                return Results.Ok(result);
            });


            app.MapGet("/api/cargo-types", async (string? search, DapperContext context) =>
            {
                var query = @"
                    SELECT DISTINCT carga_id AS CargoTypeId, nome AS CargoType
                    FROM logistica.tipo_carga
                    WHERE (@search IS NULL OR nome ILIKE '%' || @search || '%')
                    ORDER BY nome;
                ";

                using var connection = context.CreateConnection();
                var result = await connection.QueryAsync<CargoTypeBasic>(query, new { search });

                return Results.Ok(result);
            });
        }
    }
}
