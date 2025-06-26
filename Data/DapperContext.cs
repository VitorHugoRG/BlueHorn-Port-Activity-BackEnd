using System.Data;
using Npgsql;

namespace PortActivityAPI.Data
{
    public class DapperContext
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;

        public DapperContext(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("Postgres");
        }

        public IDbConnection CreateConnection() => new NpgsqlConnection(_connectionString);
    }
}
