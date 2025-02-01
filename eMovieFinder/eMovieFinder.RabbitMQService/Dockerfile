FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "eMovieFinder.RabbitMQService/eMovieFinder.RabbitMQService.csproj"

FROM build AS publish
RUN dotnet publish "eMovieFinder.RabbitMQService/eMovieFinder.RabbitMQService.csproj" -c Release -o /app/publish/rabbitmqservice

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish/rabbitmqservice .

ENTRYPOINT ["dotnet", "eMovieFinder.RabbitMQService.dll"]