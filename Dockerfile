#FROM node:latest AS node_base

#RUN echo "NODE Version:" && node --version
#RUN echo "NPM Version:" && npm --version

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

#COPY --from=node_base . .
RUN apt-get update -y && apt-get install -y nodejs npm

WORKDIR /src
COPY ./ ./

COPY . .

RUN dotnet publish -c Release -o /app /p:PASSCORE_PROVIDER=LDAP

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
COPY ca.crt /usr/local/share/ca-certificates/ca.crt
RUN apt-get update -y && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/* && update-ca-certificates
WORKDIR /app
COPY --from=build /app ./
EXPOSE 80
ENTRYPOINT ["dotnet", "Unosquare.PassCore.Web.dll"]
