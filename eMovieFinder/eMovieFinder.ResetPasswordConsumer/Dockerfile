FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "eMovieFinder.ResetPasswordConsumer/eMovieFinder.ResetPasswordConsumer.csproj"

FROM build AS publish
RUN dotnet publish "eMovieFinder.ResetPasswordConsumer/eMovieFinder.ResetPasswordConsumer.csproj" -c Release -o /app/publish/resetpasswordconsumer

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish/resetpasswordconsumer .

ENTRYPOINT ["dotnet", "eMovieFinder.ResetPasswordConsumer.dll"]