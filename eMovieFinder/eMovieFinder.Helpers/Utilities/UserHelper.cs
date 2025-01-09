using Microsoft.AspNetCore.Http;
using System;
using System.Linq;
using System.Security.Cryptography;

namespace eMovieFinder.Helpers.Utilities
{
    public class UserHelper
    {
        public static int GetIdentityUserId(IHttpContextAccessor httpContextAccessor)
        {
            var identityUserId = int.Parse(httpContextAccessor.HttpContext?
                .User?.Claims?.ToList().Find(r => r.Type == "Id")?.Value);

            return identityUserId != null ? identityUserId : 0;
        }
        public static string GenerateCode(int length, int numberOfNonAlphanumericCharacters)
        {
            const string alphanumericCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            const string nonAlphanumericCharacters = "!@#$%^&*()_-+=[{]};:<>|./?";

            var randomBytes = new byte[length];
            var chars = new char[length];
            int nonAlphanumericCount = 0;

            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(randomBytes);
            }

            for (int i = 0; i < length; i++)
            {
                if (nonAlphanumericCount < numberOfNonAlphanumericCharacters)
                {
                    int rnd = randomBytes[i] % nonAlphanumericCharacters.Length;
                    chars[i] = nonAlphanumericCharacters[rnd];
                    nonAlphanumericCount++;
                }
                else
                {
                    int rnd = randomBytes[i] % alphanumericCharacters.Length;
                    chars[i] = alphanumericCharacters[rnd];
                }
            }

            return new string(chars.OrderBy(s => Guid.NewGuid()).ToArray());
        }
    }
}
