using DotNetEnv;
using eMovieFinder.API.Filters;
using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.EmailService.Interfaces;
using eMovieFinder.EmailService.Services;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Dtos.Requests.Actor;
using eMovieFinder.Model.Dtos.Requests.Movie;
using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.Utilities;
using eMovieFinder.RabbitMQService.Interfaces;
using eMovieFinder.RabbitMQService.Services;
using eMovieFinder.Services.Interfaces;
using eMovieFinder.Services.Interfaces.ML;
using eMovieFinder.Services.Services;
using eMovieFinder.Services.Services.ML;
using Mapster;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using RabbitMQ.Client;
using System.Text;

Env.Load(@"../.env");

var builder = WebApplication.CreateBuilder(args);

var jwtSecretFromEnv = Environment.GetEnvironmentVariable("JWT_SECRET_KEY");

// This service allows us to get current logged user information
builder.Services.AddHttpContextAccessor();
// Add our ExceptionFilter to the list of filters in Dot net
builder.Services.AddControllers(f =>
{
    f.Filters.Add<ExceptionFilter>();
});

builder.Services.AddSwaggerGen(swagger =>
{
    //This is to generate the Default UI of Swagger Documentation    
    swagger.SwaggerDoc("v1", new OpenApiInfo
    {
        Version = "v1",
        Title = "ASP.NET 5 Web API",
        Description = "Authentication and Authorization in ASP.NET 5 with JWT and Swagger"
    });
    // To Enable authorization using Swagger (JWT)    
    swagger.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Enter 'Bearer' [space] and then your valid token in the text input below.\r\n\r\nExample: \"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\"",
    });
    swagger.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                          new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                                {
                                    Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                                }
                            },
                            new string[] {}
                    }
                });
});

builder.Configuration.AddEnvironmentVariables();

// Database connection
var connectionString = builder.Configuration.GetConnectionString("eMovieFinderConnection");

builder.Services.AddDbContext<EMFContext>(options =>
    options.UseSqlServer(connectionString));

// Enable Mapster
builder.Services.AddMapster();

//Jwt configuration starts here
// We load the data from appsettings.json and map it to the JwtConfig class
var key = jwtSecretFromEnv;

builder.Services.Configure<JwtConfig>(options =>
{
    options.SecretKey = key;
});
// The application will expect a Jwt token in HTTP requests and will use JwtBearer authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(jwt =>
{
    var secretKey = jwtSecretFromEnv;

    var key = Encoding.ASCII.GetBytes(secretKey);

    jwt.SaveToken = true;
    jwt.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = false,
        ValidateAudience = false,
        ValidateLifetime = true,
        RequireExpirationTime = false,
        ClockSkew = TimeSpan.Zero
    };
});
builder.Services.AddIdentity<IdentityUser<int>, IdentityRole<int>>(o =>
{
    o.SignIn.RequireConfirmedAccount = true;
    o.Password.RequireDigit = false;
    o.Password.RequireLowercase = false;
    o.Password.RequireUppercase = false;
    o.Password.RequireNonAlphanumeric = false;
    o.Password.RequiredLength = 0;
})
    .AddEntityFrameworkStores<EMFContext>()
    .AddDefaultTokenProviders();
//Jwt configuration ends here

// Add services to the container
builder.Services.AddSingleton<IEmailService, EmailService>();
builder.Services.AddScoped<IMovieService, MovieService>();
builder.Services.AddScoped<IActorService, ActorService>();
builder.Services.AddScoped<IMovieActorService, MovieActorService>();
builder.Services.AddScoped<IMovieCategoryService, MovieCategoryService>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<ICountryService, CountryService>();
builder.Services.AddScoped<IDirectorService, DirectorService>();
builder.Services.AddScoped<IMovieFavouriteService, MovieFavouriteService>();
builder.Services.AddScoped<IMovieReviewService, MovieReviewService>();
builder.Services.AddScoped<IAuthManagementService, AuthManagementService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<ICartService, CartService>();
builder.Services.AddScoped<IRecommenderTrainService, RecommenderTrainService>();
builder.Services.AddScoped<IRecommenderPredictService, RecommenderPredictService>();
builder.Services.AddSingleton<IRabbitMQService, RabbitMQService>();
builder.Services.AddScoped<IUserAccountService, UserAccountService>();
builder.Services.AddScoped<IOrderService, OrderService>();

//RabbitMQ connection
builder.Services.AddSingleton<IConnectionFactory>(sp =>
{
    var hostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST");
    var userName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME");
    var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD");

    return new ConnectionFactory()
    {
        HostName = hostName,
        UserName = userName,
        Password = password,
        RequestedHeartbeat = TimeSpan.FromSeconds(60),
        AutomaticRecoveryEnabled = true
    };
});

void ConfigureMappings()
{
    TypeAdapterConfig<ActorUpdateRequest, Actor>.NewConfig()
        .IgnoreNullValues(true)
        .Map(dest => dest.FirstName, src => !string.IsNullOrEmpty(src.FirstName) ? src.FirstName : default)
        .Map(dest => dest.LastName, src => !string.IsNullOrEmpty(src.LastName) ? src.LastName : default)
        .Map(dest => dest.Image, src => src.Image != null ? src.Image : default)
        .Map(dest => dest.BirthDate, src => src.BirthDate != null ? src.BirthDate : default)
        .Map(dest => dest.CountryId, src => src.CountryId != null ? src.CountryId : default)
        .Map(dest => dest.IMDbLink, src => !string.IsNullOrEmpty(src.IMDbLink) ? src.IMDbLink : default)
        .Map(dest => dest.Biography, src => !string.IsNullOrEmpty(src.Biography) ? src.Biography : default);

    TypeAdapterConfig<UserUpdateRequest, User>.NewConfig()
        .IgnoreNullValues(true)
        .Map(dest => dest.Image, src => src.Image != null ? src.Image : default);

    TypeAdapterConfig<UserInsertRequest, User>.NewConfig()
        .IgnoreNullValues(true)
        .Map(dest => dest.Image, src => src.Image != null ? src.Image : default);

    TypeAdapterConfig<MovieUpdateRequest, Movie>.NewConfig()
        .IgnoreNullValues(true)
        .Map(dest => dest.Title, src => !string.IsNullOrEmpty(src.Title) ? src.Title : default)
        .Map(dest => dest.ReleaseDate, src => src.ReleaseDate != null ? src.ReleaseDate : default)
        .Map(dest => dest.Duration, src => src.Duration != null ? src.Duration : default)
        .Map(dest => dest.DirectorId, src => src.DirectorId != null ? src.DirectorId : default)
        .Map(dest => dest.CountryId, src => src.CountryId != null ? src.CountryId : default)
        .Map(dest => dest.TrailerLink, src => !string.IsNullOrEmpty(src.TrailerLink) ? src.TrailerLink : default)
        .Map(dest => dest.Image, src => src.Image != null ? src.Image : default)
        .Map(dest => dest.StoryLine, src => !string.IsNullOrEmpty(src.StoryLine) ? src.StoryLine : default)
        .Map(dest => dest.Price, src => src.Price != null ? src.Price : default)
        .Map(dest => dest.MovieState, src => src.MovieState.HasValue
        ? (MovieStatesEnumeration.MovieStatesEnum)src.MovieState.Value : default)
        .Map(dest => dest.Discount, src => src.Discount != null ? src.Discount : default)
        .Map(dest => dest.AverageRating, src => src.AverageRating != null ? src.AverageRating : default)
        .Map(dest => dest.MovieCategories, src => src.Categories != null
        ? src.Categories.Select(categoryId => new MovieCategory { CategoryId = categoryId }).ToList()
        : default)
        .Map(dest => dest.MovieActors, src => src.Actors != null
        ? src.Actors.Select(actorId => new MovieActor { ActorId = actorId }).ToList()
        : default);
}

builder.Services.AddEndpointsApiExplorer();

ConfigureMappings();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<EMFContext>();

    dataContext.Database.Migrate();
}

app.Run();


