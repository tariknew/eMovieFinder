using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Utilities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Net;

namespace eMovieFinder.API.Filters
{
    public class ExceptionFilter : ExceptionFilterAttribute
    {
        ILogger<ExceptionFilter> _logger;
        private readonly EMFContext _context;
        public ExceptionFilter(EMFContext context, ILogger<ExceptionFilter> logger)
        {
            _logger = logger;
            _context = context;
        }
        public override void OnException(ExceptionContext context)
        {
            _logger.LogError(context.Exception, context.Exception.Message);

            if (context.Exception is UserException)
            {
                context.ModelState.AddModelError("USERERROR", context.Exception.Message);
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.BadRequest;
            }
            else
            {
                context.ModelState.AddModelError("ERROR", "Server side error, please check logs");
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            }

            var list = context.ModelState.Where(x => x.Value.Errors.Count() > 0)
                .ToDictionary(x => x.Key, y => y.Value.Errors.Select(z => z.ErrorMessage));

            context.Result = new JsonResult(new { errors = list });

            var exceptionLog = new ExceptionLog
            {
                Message = context.Exception.Message,
                StatusCode = context.HttpContext.Response.StatusCode,
                StackTrace = context.Exception.StackTrace,
                CreationDate = DateTime.Now
            };

            _context.ExceptionLogs.Add(exceptionLog);
            _context.SaveChanges();
        }
    }
}
