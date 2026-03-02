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

## Licencia

MIT License - Sientete libre de usar este template en tus proyectos.
