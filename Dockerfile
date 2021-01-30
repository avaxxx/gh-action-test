FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["gh-action-test.csproj", "./"]
RUN dotnet restore "gh-action-test.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "gh-action-test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "gh-action-test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "gh-action-test.dll"]
