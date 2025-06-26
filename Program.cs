using PortActivityAPI.Data;
using PortActivityAPI.Endpoints;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddSingleton<DapperContext>();


builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();


app.UseCors("AllowAll");


app.MapPortEndpoints();

app.Run();