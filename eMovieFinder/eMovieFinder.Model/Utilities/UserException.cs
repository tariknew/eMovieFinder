using System;

namespace eMovieFinder.Model.Utilities
{
    public class UserException : Exception
    {
        public UserException(string message) : base(message) { }
    }
}
