FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5055
ENV ASPNETCORE_URLS=http://+:5055

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "eMovieFinder.API/eMovieFinder.API.csproj"
RUN dotnet build "eMovieFinder.API/eMovieFinder.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "eMovieFinder.API/eMovieFinder.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

RUN mkdir -p /app/RecommenderModels && \
    chmod 777 /app/RecommenderModels

COPY eMovieFinder.API/RecommenderModels/. /app/RecommenderModels/

ENTRYPOINT ["dotnet", "eMovieFinder.API.dll"]
