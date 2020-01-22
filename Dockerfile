FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src

# Keep the project list and command dotnet restore identical in all Dockfiles to maximize image cache utilization
COPY eShopOnContainers-ServicesAndWebApps.sln .
COPY OcelotApiGw/OcelotApiGw.csproj /src/OcelotApiGw/
RUN dotnet restore eShopOnContainers-ServicesAndWebApps.sln

COPY . .
WORKDIR /src/OcelotApiGw/
RUN dotnet publish --no-restore -c Release -o /app

FROM build AS publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "OcelotApiGw.dll"]
