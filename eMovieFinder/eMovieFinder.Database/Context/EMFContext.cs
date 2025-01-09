using eMovieFinder.Database.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace eMovieFinder.Database.Context
{
    public partial class EMFContext : IdentityDbContext<IdentityUser<int>, IdentityRole<int>, int>
    {
        private readonly IConfiguration _configuration;
        public EMFContext() { }
        public EMFContext(DbContextOptions<EMFContext> options, IConfiguration configuration) : base(options)
        {
            _configuration = configuration;
        }
        public virtual DbSet<Actor> Actors { get; set; }
        public virtual DbSet<Category> Categories { get; set; }
        public virtual DbSet<Country> Countries { get; set; }
        public virtual DbSet<Director> Directors { get; set; }
        public virtual DbSet<Movie> Movies { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<MovieActor> MovieActors { get; set; }
        public virtual DbSet<MovieCategory> MovieCategories { get; set; }
        public virtual DbSet<MovieFavourite> MovieFavourites { get; set; }
        public virtual DbSet<MovieReview> MovieReviews { get; set; }
        public virtual DbSet<ExceptionLog> ExceptionLogs { get; set; }
        public virtual DbSet<UserToken> UserTokens { get; set; }
        public virtual DbSet<Cart> Carts { get; set; }
        public virtual DbSet<CartItem> CartItems { get; set; }
        public virtual DbSet<Order> Orders { get; set; }
        public virtual DbSet<OrderMovie> OrderMovies { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Cart>()
            .Property(x => x.CartTotalPrice)
            .HasPrecision(18, 2);

            modelBuilder.Entity<CartItem>()
            .Property(x => x.FinalMoviePrice)
            .HasPrecision(18, 2);

            modelBuilder.Entity<Movie>()
            .Property(x => x.Discount)
            .HasPrecision(18, 2);

            OnModelCreatingPartial(modelBuilder);
        }
        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
