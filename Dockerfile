FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["FakeApi/FakeApi.csproj", "FakeApi/"]
RUN dotnet restore "FakeApi/FakeApi.csproj"
COPY . .
WORKDIR "/src/FakeApi"
RUN dotnet build "FakeApi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "FakeApi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "FakeApi.dll"]