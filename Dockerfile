
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG TARGETARCH
ARG RUNTIME=linux-${TARGETARCH}
WORKDIR /src

# Copy project and restore dependencies
COPY ["carsApi.csproj", "./"]
RUN dotnet restore --runtime $RUNTIME

# Copy everything else and publish
COPY . ./
RUN dotnet publish "carsApi.csproj" --runtime $RUNTIME --self-contained false -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
EXPOSE 8080



COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "carsApi.dll"]



# FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# ARG TARGETARCH
# WORKDIR /app

# # Copy project file
# COPY *.csproj ./

# RUN dotnet restore -a $TARGETARCH

# # Copy source code and publish app
# COPY . ./
# RUN dotnet publish -a $TARGETARCH --no-restore -o /app


# # Runtime stage
# FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
# EXPOSE 8000
# WORKDIR /app
# COPY  --from=build /app .
# USER $APP_UID
# ENTRYPOINT ["./aspnetapp"]
