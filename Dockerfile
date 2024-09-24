FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

RUN apt-get update -y && apt-get install -y nodejs npm

WORKDIR /src
COPY ./ ./

COPY . .

RUN dotnet publish -c Release -o /app /p:PASSCORE_PROVIDER=LDAP

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
EXPOSE 80
ENTRYPOINT ["dotnet", "Unosquare.PassCore.Web.dll"]
