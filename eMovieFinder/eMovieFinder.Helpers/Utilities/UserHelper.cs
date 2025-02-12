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
        public static string GenerateCode(int length)
        {
            const string alphanumericCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

            var randomBytes = new byte[length];
            var chars = new char[length];

            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(randomBytes);
            }

            for (int i = 0; i < length; i++)
            {
                int rnd = randomBytes[i] % alphanumericCharacters.Length;
                chars[i] = alphanumericCharacters[rnd];
            }

            return new string(chars.OrderBy(s => Guid.NewGuid()).ToArray());
        }
    }
}
