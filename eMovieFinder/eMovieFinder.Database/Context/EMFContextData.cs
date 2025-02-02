using eMovieFinder.Database.Entities;
using eMovieFinder.Helpers.Utilities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Database.Context
{
    public partial class EMFContext
    {
        partial void OnModelCreatingPartial(ModelBuilder modelBuilder)
        {
            //IdentityUsers
            modelBuilder.Entity<IdentityUser<int>>().HasData(new IdentityUser<int>
            {
                Id = 1,
                UserName = "tarikadmin",
                NormalizedUserName = "TARIKADMIN",
                Email = "tarik.smajlovic@edu.fit.ba",
                NormalizedEmail = "TARIK.SMAJLOVIC@EDU.FIT.BA",
                EmailConfirmed = true,
                PasswordHash = "AQAAAAEAACcQAAAAEJUkMFSXrboURChAEJiqUu1pLXzvH61yPUTqsdQk0P+6c4XkL24mAg4uTtrs2BdHsA==", // Password = test
                SecurityStamp = "d3a50ebf-5215-4039-9e5e-134405f033a6",
                ConcurrencyStamp = "f8761f6c-a02d-4e48-81da-95585f418954",
                PhoneNumberConfirmed = false,
                TwoFactorEnabled = false,
                LockoutEnabled = true,
                AccessFailedCount = 0
            },
            new IdentityUser<int>
            {
                Id = 2,
                UserName = "tarikuser",
                NormalizedUserName = "TARIKUSER",
                Email = "test@example.com",
                NormalizedEmail = "TEST@EXAMPLE.COM",
                EmailConfirmed = true,
                PasswordHash = "AQAAAAEAACcQAAAAEJUkMFSXrboURChAEJiqUu1pLXzvH61yPUTqsdQk0P+6c4XkL24mAg4uTtrs2BdHsA==", // Password = test
                SecurityStamp = "d3a50ebf-5215-4039-9e5e-134405f033a6",
                ConcurrencyStamp = "f8761f6c-a02d-4e48-81da-95585f418954",
                PhoneNumberConfirmed = false,
                TwoFactorEnabled = false,
                LockoutEnabled = true,
                AccessFailedCount = 0
            },
            new IdentityUser<int>
            {
                Id = 3,
                UserName = "tariksuper",
                NormalizedUserName = "TARIKSUPER",
                Email = "example@example.com",
                NormalizedEmail = "EXAMPLE@EXAMPLE.COM",
                EmailConfirmed = true,
                PasswordHash = "AQAAAAEAACcQAAAAEJUkMFSXrboURChAEJiqUu1pLXzvH61yPUTqsdQk0P+6c4XkL24mAg4uTtrs2BdHsA==", // Password = test
                SecurityStamp = "d3a50ebf-5215-4039-9e5e-134405f033a6",
                ConcurrencyStamp = "f8761f6c-a02d-4e48-81da-95585f418954",
                PhoneNumberConfirmed = false,
                TwoFactorEnabled = false,
                LockoutEnabled = true,
                AccessFailedCount = 0
            }, new IdentityUser<int>
            {
                Id = 4,
                UserName = "tarikbuyer",
                NormalizedUserName = "TARIKBUYER",
                Email = "examplecustomer@example.com",
                NormalizedEmail = "EXAMPLECUSTOMER@EXAMPLE.COM",
                EmailConfirmed = true,
                PasswordHash = "AQAAAAEAACcQAAAAEJUkMFSXrboURChAEJiqUu1pLXzvH61yPUTqsdQk0P+6c4XkL24mAg4uTtrs2BdHsA==", // Password = test
                SecurityStamp = "d3a50ebf-5215-4039-9e5e-134405f033a6",
                ConcurrencyStamp = "f8761f6c-a02d-4e48-81da-95585f418954",
                PhoneNumberConfirmed = false,
                TwoFactorEnabled = false,
                LockoutEnabled = true,
                AccessFailedCount = 0
            });

            //Roles
            modelBuilder.Entity<IdentityRole<int>>().HasData(new IdentityRole<int>
            {
                Id = 1,
                Name = "Administrator",
                NormalizedName = "ADMINISTRATOR",
                ConcurrencyStamp = "1954fd8e-8fe0-48e9-836c-2cdcccf89ef0"
            },
            new IdentityRole<int>
            {
                Id = 2,
                Name = "User",
                NormalizedName = "USER",
                ConcurrencyStamp = "31d72aba-bc66-414c-979b-ed57c9a247b0"
            }, new IdentityRole<int>
            {
                Id = 3,
                Name = "Customer",
                NormalizedName = "CUSTOMER",
                ConcurrencyStamp = "31d72aba-bc66-414c-979b-ed57c9a247b0"
            });

            //UserRoles
            modelBuilder.Entity<IdentityUserRole<int>>().HasData(new IdentityUserRole<int>
            {
                RoleId = 1,
                UserId = 1
            },
            new IdentityUserRole<int>
            {
                RoleId = 2,
                UserId = 2
            },
            new IdentityUserRole<int>
            {
                RoleId = 1,
                UserId = 3
            },
            new IdentityUserRole<int>
            {
                RoleId = 2,
                UserId = 3
            }, new IdentityUserRole<int>
            {
                RoleId = 3,
                UserId = 4
            });

            //Users
            modelBuilder.Entity<User>().HasData(new User
            {
                Id = 1,
                IdentityUserId = 1
            },
            new User
            {
                Id = 2,
                IdentityUserId = 2
            },
            new User
            {
                Id = 3,
                IdentityUserId = 3
            }, new User
            {
                Id = 4,
                Image = ImageHelper.ConvertImageToBytes(_configuration["UserImages:tarikbuyer"]),
                IdentityUserId = 4
            });

            //Countries
            modelBuilder.Entity<Country>().HasData(new Country
            {
                Id = 1,
                CountryName = "New Zealand",
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Country
            {
                Id = 2,
                CountryName = "United States",
                CreationDate = DateTime.Now,
                CreatedById = 1
            });

            //Categories
            modelBuilder.Entity<Category>().HasData(new Category
            {
                Id = 1,
                CategoryName = "Action",
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Category
            {
                Id = 2,
                CategoryName = "Crime",
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Category
            {
                Id = 3,
                CategoryName = "Comedy",
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Category
            {
                Id = 4,
                CategoryName = "Drama",
                CreationDate = DateTime.Now,
                CreatedById = 1
            });

            //Actors
            modelBuilder.Entity<Actor>().HasData(new Actor
            {
                Id = 1,
                FirstName = "Emma",
                LastName = "Stone",
                BirthDate = new DateTime(1988, 11, 6),
                CountryId = 2,
                Biography = "Emily Jean \"Emma\" Stone (born November 6, 1988) is an American actress. The recipient of numerous accolades, including two Academy Awards and two Golden Globe Award, she was the world's highest-paid actress in 2017. Born and raised in Scottsdale, Arizona, Stone began acting as a child, in a theater production of The Wind in the Willows in 2000. As a teenager, she relocated to Los Angeles with her mother and made her television debut in In Search of the New Partridge Family (2004), a reality show that produced only an unsold pilot. After small television roles, she made her film debut in Superbad (2007), and received positive media attention for her role in Zombieland (2009).",
                IMDbLink = "nm1297015",
                Image = ImageHelper.ConvertImageToBytes(_configuration["ActorsImages:Emma Stone"]),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Actor
            {
                Id = 2,
                FirstName = "Willem",
                LastName = "Dafoe",
                BirthDate = new DateTime(1955, 07, 22),
                CountryId = 2,
                Biography = "William James \"Willem\" Dafoe (born July 22, 1955) is an American actor. He is the recipient of various accolades, including the Volpi Cup for Best Actor, in addition to receiving nominations for four Academy Awards, four Screen Actors Guild Awards, three Golden Globe Awards, and a British Academy Film Award. He frequently collaborates with filmmakers Paul Schrader, Abel Ferrara, Lars von Trier, Julian Schnabel, Wes Anderson, and Robert Eggers. Dafoe was an early member of experimental theater company The Wooster Group. He made his film debut in Heaven's Gate (1980), but was fired during production. He had his first leading role in the outlaw biker film The Loveless (1982) and then played the main antagonist in Streets of Fire (1984) and To Live and Die in L.A. (1985). He received his first Academy Award nomination (as Best Supporting Actor) for his role as Sergeant Elias Grodin in Oliver Stone's war film Platoon (1986).",
                IMDbLink = "nm0000353",
                Image = ImageHelper.ConvertImageToBytes(_configuration["ActorsImages:Willem Dafoe"]),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Actor
            {
                Id = 3,
                FirstName = "Mark",
                LastName = "Ruffalo",
                BirthDate = new DateTime(1967, 11, 22),
                CountryId = 2,
                Biography = "Mark Alan Ruffalo (born November 22, 1967) is an American actor and producer. He began acting in the early 1990s and first gained recognition for his work in Kenneth Lonergan's play This Is Our Youth (1998) and drama film You Can Count on Me (2000). He went on to star in the romantic comedies 13 Going on 30 (2004) and Just like Heaven (2005) and the thrillers In the Cut (2003), Zodiac (2007) and Shutter Island (2010). He received a Tony Award nomination for his supporting role in the Broadway revival of Awake and Sing! in 2006. Ruffalo gained international recognition for playing Bruce Banner / Hulk in superhero films set in the Marvel Cinematic Universe, including The Avengers (2012), Avengers: Infinity War (2018), and Avengers: Endgame (2019). Ruffalo gained nominations for the Academy Award for Best Supporting Actor for playing a sperm-donor in the comedy-drama The Kids Are All Right (2010), Dave Schultz in the biopic Foxcatcher (2014), and Michael Rezendes in the drama Spotlight (2015).",
                IMDbLink = "nm0749263",
                Image = ImageHelper.ConvertImageToBytes(_configuration["ActorsImages:Mark Ruffalo"]),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Actor
            {
                Id = 4,
                FirstName = "Ramy",
                LastName = "Youssef",
                BirthDate = new DateTime(1991, 03, 26),
                CountryId = 2,
                Biography = "Ramy Youssef (born March 26, 1991) is an American stand-up comedian, actor, and writer of Egyptian descent. Youssef made his acting debut in the Nick@Nite sitcom See Dad Run. In 2019, Youssef made his breakthrough with Ramy, a show Youssef created, produced and starred in. Youssef received a Golden Globe Award for Best Actor in a Television Series for his performance.",
                IMDbLink = "nm3858973",
                Image = ImageHelper.ConvertImageToBytes(_configuration["ActorsImages:Ramy Youssef"]),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Actor
            {
                Id = 5,
                FirstName = "Christopher",
                LastName = "Abbott",
                BirthDate = new DateTime(1986, 02, 10),
                CountryId = 2,
                Biography = "Christopher Jacob Abbott (born February 10, 1986) is an American actor. Abbott made his feature film debut in Martha Marcy May Marlene (2011). Abbott's other notable films include Hello I Must Be Going (2012), The Sleepwalker (2014) and A Most Violent Year (2014). In 2015, Abbott starred as the title character in the critically acclaimed film James White. Abbott is mostly known for his role as Charlie Dattolo in the HBO comedy-drama series Girls. Abbott has also had an extensive career on stage, having performed in both Broadway and Off-Broadway productions.",
                IMDbLink = "nm3571592",
                Image = ImageHelper.ConvertImageToBytes(_configuration["ActorsImages:Christopher Abbott"]),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Actor
            {
                Id = 6,
                FirstName = "Jerrod",
                LastName = "Carmichael",
                BirthDate = new DateTime(1987, 06, 22),
                CountryId = 2,
                Biography = "Rothaniel Jerrod Carmichael (born April 7, 1987) is an American stand-up comedian, actor, and filmmaker. He has released three stand-up comedy specials on HBO: Love at the Store (2014), 8 (2017), and Rothaniel (2022). He also co-created, co-wrote, produced, and starred in the semi-biographical NBC sitcom The Carmichael Show (2015–2017).",
                IMDbLink = "nm4273797",
                Image = ImageHelper.ConvertImageToBytes(_configuration["ActorsImages:Jerrod Carmichael"]),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Actor
            {
                Id = 7,
                FirstName = "Margaret",
                LastName = "Qualley",
                BirthDate = new DateTime(1994, 10, 23),
                CountryId = 2,
                Biography = "Sarah Margaret Qualley (born October 23, 1994) is an American actress. The daughter of actress Andie MacDowell, she trained as a ballerina in her youth and briefly pursued a career in modeling. She made her acting debut with a minor role in the 2013 drama film Palo Alto and gained recognition for playing a troubled teenager in the HBO drama series The Leftovers (2014–2017). Qualley then appeared in the dark comedy The Nice Guys (2016) and in Netflix's supernatural thriller Death Note (2017). Qualley gained acclaim and a nomination for a Primetime Emmy Award for portraying actress and dancer Ann Reinking in the FX biographical drama miniseries Fosse/Verdon (2019) and the title role in the Netflix drama miniseries Maid (2021). Her biggest commercial IsSuccess came with Quentin Tarantino's comedy-drama Once Upon a Time in Hollywood (2019).",
                IMDbLink = "nm4960279",
                Image = ImageHelper.ConvertImageToBytes(_configuration["ActorsImages:Margaret Qualley"]),
                CreationDate = DateTime.Now,
                CreatedById = 1
            });

            //Directors
            modelBuilder.Entity<Director>().HasData(new Director
            {
                Id = 1,
                FirstName = "Peter",
                LastName = "Jackson",
                BirthDate = new DateTime(1961, 10, 31),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Director
            {
                Id = 2,
                FirstName = "Martin",
                LastName = "Scorsese",
                BirthDate = new DateTime(1942, 11, 17),
                CreationDate = DateTime.Now,
                CreatedById = 1
            },
            new Director
            {
                Id = 3,
                FirstName = "Yorgos",
                LastName = "Lanthimos",
                BirthDate = new DateTime(1973, 9, 23),
                CreationDate = DateTime.Now,
                CreatedById = 1
            });

            //Movies
            modelBuilder.Entity<Movie>().HasData(new Movie
            {
                Id = 1,
                CountryId = 1,
                DirectorId = 1,
                Duration = 178,
                ReleaseDate = new DateTime(2001, 12, 19),
                CreationDate = new DateTime(2024, 10, 28),
                CreatedById = 1,
                Price = 5,
                Discount = 35,
                AverageRating = 4.0,
                MovieState = MovieStatesEnumeration.MovieStatesEnum.Published,
                Image = ImageHelper.ConvertImageToBytes(_configuration["MoviesImages:The Lord of the Rings: The Fellowship of the Ring"]),
                StoryLine = "A meek hobbit of the Shire and eight companions set out on a journey to Mount Doom to destroy the One Ring and the dark lord Sauron.",
                Title = "The Lord of the Rings: The Fellowship of the Ring",
                TrailerLink = "V75dMMIW2B4",
            }, new Movie
            {
                Id = 2,
                CountryId = 2,
                DirectorId = 2,
                Duration = 151,
                ReleaseDate = new DateTime(2006, 10, 6),
                CreationDate = new DateTime(2024, 10, 27),
                CreatedById = 1,
                Price = 10,
                Discount = 15,
                AverageRating = 4.0,
                MovieState = MovieStatesEnumeration.MovieStatesEnum.Published,
                Image = ImageHelper.ConvertImageToBytes(_configuration["MoviesImages:The Departed"]),
                StoryLine = "An undercover cop and a mole in the police attempt to identify each other while infiltrating an Irish gang in South Boston.",
                Title = "The Departed",
                TrailerLink = "yicP7ZEEz1k"
            }, new Movie
            {
                Id = 3,
                CountryId = 2,
                DirectorId = 3,
                Duration = 141,
                ReleaseDate = new DateTime(2023, 12, 8),
                CreationDate = new DateTime(2023, 10, 10),
                CreatedById = 1,
                Price = 12,
                AverageRating = 4.0,
                MovieState = MovieStatesEnumeration.MovieStatesEnum.Published,
                Image = ImageHelper.ConvertImageToBytes(_configuration["MoviesImages:Poor Things"]),
                StoryLine = "Brought back to life by an unorthodox scientist, a young woman runs off with a lawyer on a whirlwind adventure across the continents. Free from the prejudices of her times, she grows steadfast in her purpose to stand for equality and liberation.",
                Title = "Poor Things",
                TrailerLink = "JrgqAjKyxIE"
            });

            // MoviesCategories
            modelBuilder.Entity<MovieCategory>().HasData(new MovieCategory
            {
                Id = 1,
                CategoryId = 1,
                MovieId = 1
            },
            new MovieCategory
            {
                Id = 2,
                CategoryId = 1,
                MovieId = 2
            },
            new MovieCategory
            {
                Id = 3,
                CategoryId = 1,
                MovieId = 1
            },
            new MovieCategory
            {
                Id = 4,
                CategoryId = 1,
                MovieId = 3
            },
            new MovieCategory
            {
                Id = 5,
                CategoryId = 2,
                MovieId = 1
            },
            new MovieCategory
            {
                Id = 6,
                CategoryId = 2,
                MovieId = 2
            },
            new MovieCategory
            {
                Id = 7,
                CategoryId = 2,
                MovieId = 1
            },
            new MovieCategory
            {
                Id = 8,
                CategoryId = 2,
                MovieId = 3
            },
            new MovieCategory
            {
                Id = 9,
                CategoryId = 3,
                MovieId = 1
            },
            new MovieCategory
            {
                Id = 10,
                CategoryId = 3,
                MovieId = 2
            },
            new MovieCategory
            {
                Id = 11,
                CategoryId = 3,
                MovieId = 1
            },
            new MovieCategory
            {
                Id = 12,
                CategoryId = 3,
                MovieId = 3
            });

            //MoviesActors
            modelBuilder.Entity<MovieActor>().HasData(new MovieActor
            {
                Id = 1,
                MovieId = 3,
                ActorId = 1,
                CharacterName = "Bella Baxter"
            },
            new MovieActor
            {
                Id = 2,
                MovieId = 3,
                ActorId = 2,
                CharacterName = "Dr Godwin Baxter"
            },
            new MovieActor
            {
                Id = 3,
                MovieId = 3,
                ActorId = 3,
                CharacterName = "Duncan Wedderburn"
            },
            new MovieActor
            {
                Id = 4,
                MovieId = 3,
                ActorId = 4,
                CharacterName = "Max McCandles"
            },
            new MovieActor
            {
                Id = 5,
                MovieId = 3,
                ActorId = 5,
                CharacterName = "Alfie Blessington"
            },
            new MovieActor
            {
                Id = 6,
                MovieId = 3,
                ActorId = 6,
                CharacterName = "Harry Astley"
            },
             new MovieActor
             {
                 Id = 7,
                 MovieId = 3,
                 ActorId = 7,
                 CharacterName = "Felicity"
             });

            // MovieFavourites
            modelBuilder.Entity<MovieFavourite>().HasData(new MovieFavourite
            {
                Id = 1,
                UserId = 1,
                MovieId = 1
            },
            new MovieFavourite
            {
                Id = 2,
                UserId = 1,
                MovieId = 2
            },
            new MovieFavourite
            {
                Id = 3,
                UserId = 2,
                MovieId = 1
            },
            new MovieFavourite
            {
                Id = 4,
                UserId = 2,
                MovieId = 2
            },
            new MovieFavourite
            {
                Id = 5,
                UserId = 3,
                MovieId = 2
            },
            new MovieFavourite
            {
                Id = 6,
                UserId = 3,
                MovieId = 3
            });

            //MovieReviews
            modelBuilder.Entity<MovieReview>().HasData(new MovieReview
            {
                Id = 1,
                Rating = 4,
                Comment = "Great movie!",
                UserId = 4,
                MovieId = 1,
                CreationDate = DateTime.Now,
                CreatedById = 4
            },
            new MovieReview
            {
                Id = 2,
                Rating = 4,
                Comment = "Great movie!",
                UserId = 4,
                MovieId = 2,
                CreationDate = DateTime.Now,
                CreatedById = 4
            },
            new MovieReview
            {
                Id = 3,
                Rating = 4,
                Comment = "Great movie!",
                UserId = 4,
                MovieId = 3,
                CreationDate = DateTime.Now,
                CreatedById = 4
            });

            //Order
            modelBuilder.Entity<Order>().HasData(new Order
            {
                Id = 1,
                UserId = 2,
                OrderDate = DateTime.Now
            });

            //OrderMovie
            modelBuilder.Entity<OrderMovie>().HasData(new OrderMovie
            {
                Id = 1,
                OrderId = 1,
                MovieId = 1
            });
        }
    }
}
