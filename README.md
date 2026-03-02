# .NET 8 Backend Template

Template profesional para proyectos ASP.NET Core Web API con arquitectura limpia.

## Caracteristicas

- **.NET 8.0** - Ultima version LTS
- **Arquitectura Limpia** - Separacion en capas (Domain, Application, API)
- **OperationResponse<T>** - Patron Builder para respuestas estandarizadas
- **BaseService** - Servicio base con auditoria completa y Soft Delete
- **Entity Framework Core** - ORM con PostgreSQL
- **FluentValidation** - Validacion de DTOs
- **JWT Authentication** - Seguridad con JSON Web Tokens
- **Swagger/OpenAPI** - Documentacion automatica
- **Global Usings** - Codigo limpio sin repeticion de usings
- **Docker & Docker Compose** - Despliegue containerizado
- **Observabilidad** - OpenTelemetry con Grafana, Prometheus, Loki y Tempo

## Estructura del Proyecto

```
src/
├── BackendTemplate.Domain/         # Entidades e interfaces
├── BackendTemplate.Application/    # Logica de negocio, Servicios, DTOs
└── BackendTemplate.API/           # Web API, Controladores, Middlewares
```

## Instalacion Rapida

### 1. Clonar el repositorio

```bash
git clone https://github.com/TU_USUARIO/dotnet-8-backend-template.git
cd dotnet-8-backend-template
```

### 2. Renombrar el proyecto

```powershell
# En Windows PowerShell
.\Rename-Template.ps1 -NewName MiNuevoProyecto
```

Este script renombrara:
- Carpetas (BackendTemplate.API -> MiNuevoProyecto.API)
- Archivos (.csproj, .sln, etc.)
- Namespaces en todo el codigo

### 3. Ejecutar

```bash
dotnet build
dotnet run
```

Swagger estara disponible en: `http://localhost:5252/swagger`

## Configuracion

### Base de Datos

Edita `appsettings.json` para configurar la conexion a PostgreSQL:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=MiDB;Username=usr;Password=pass"
  }
}
```

### JWT

Edita la configuracion del token en `appsettings.json`:

```json
{
  "Jwt": {
    "Issuer": "MiProyecto",
    "Audience": "MiProyecto", 
    "SecretKey": "TuClaveSecretaDeAlMenos32Caracteres"
  }
}
```

## Uso del BaseService

```csharp
public class MiEntidadService : BaseService
{
    public async Task<OperationResponse<MiEntidadDto>> Create(MiEntidadDto dto)
    {
        // La auditoria se maneja automaticamente
        return await InsertAsync<MiEntidad, MiEntidadDto>(dto, _context);
    }
}
```

## Entidades con Soft Delete

Para usar Soft Delete, implementa `IFullAuditableEntity`:

```csharp
public class MiEntidad : IFullAuditableEntity
{
    public int Id { get; set; }
    public string Nombre { get; set; }
    
    // Auditoria
    public string CreadoPor { get; set; }
    public DateTime CreadoEl { get; set; }
    public string ModificadoPor { get; set; }
    public DateTime? ModificadoEl { get; set; }
    
    // Soft Delete
    public bool IsDeleted { get; set; }
    public string EliminadoPor { get; set; }
    public DateTime? EliminadoEl { get; set; }
    public string MotivoBaja { get; set; }
}
```

## Docker

### Build y Run con Docker Compose

```bash
docker-compose up --build
```

Esto iniciara todos los servicios:
- **API**: http://localhost:8080
- **Swagger**: http://localhost:8080/swagger
- **Health Check**: http://localhost:8080/health
- **PostgreSQL**: localhost:5432
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- **Loki**: http://localhost:3100
- **Tempo**: http://localhost:3200

### Build Manual

```bash
# Build de la imagen
docker build -t backendtemplate-api ./BackendTemplate.API

# Run del contenedor
docker run -p 8080:8080 backendtemplate-api
```

## Observabilidad

El template incluye integracion completa con **OpenTelemetry** para metricas, trazas y logs.

### Métricas (Prometheus)

Las metricas estaran disponibles en `/metrics`:
- metricas HTTP requests
- metricas de runtime (.NET)
- metricas personalizadas

Acceso: `http://localhost:8080/metrics`

### Trazas (Tempo)

Las trazas se envian automaticamente a Tempo via OTLP (gRPC) en el puerto `4317`.

### Logs (Loki)

Los logs se configuran automaticamente via OTLP. Busca en Grafana con el datasource Loki.

### Configuracion de OpenTelemetry

Las variables de entorno configuradas en docker-compose:

```yaml
environment:
  - OTEL_EXPORTER_OTLP_ENDPOINT=http://tempo:4317
  - OTEL_EXPORTER_OTLP_LOGS_ENDPOINT=http://loki:3100/otlp/v1/logs
  - OTEL_SERVICE_NAME=BackendTemplate-API
```

Para desarrollo local sin Docker, las metricas se mostraran en consola.

### Dashboards Recomendados en Grafana

1. **HTTP Metrics** - Requests, latencia, errores
2. **Runtime Metrics** - GC, memoria, threads
3. **Distributed Tracing** - Trazas de requests

## Licencia

MIT License - Sientete libre de usar este template en tus proyectos.
