using System;

namespace eMovieFinder.Helpers.Utilities
{
    public class ImageHelper
    {
        public static byte[] ConvertImageToBytes(string base64img)
        {
            var base64arr = base64img.Split(',');
            string base64str = base64arr.Length > 1 ? base64arr[1] : base64img;
            string processed = base64str.Replace('_', '/').Replace('-', '+');
            switch (processed.Length % 4)
            {
                case 2:
                    processed += "==";
                    break;
                case 3:
                    processed += "=";
                    break;
            }
            byte[] picture = Convert.FromBase64String(processed);

            return picture;
        }
    }
}