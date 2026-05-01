# EsquemaPILARES

Prototipo de nueva interfaz UX/UI para la **Boleta de Atenciones** del sistema PILARES (Subsistema de Educación Comunitaria — CDMX).

## Problema

El sistema oficial en `registro.pilares.cdmx.gob.mx` requiere llenar una tabla mensual de atenciones celda por celda mediante modales. Cada celda implica 6 pasos: abrir modal → seleccionar tipo → ingresar cantidad → guardar → confirmar → cerrar. Con ~150+ celdas por mes, el proceso tarda más de 20 minutos.

**Objetivo:** reducir el tiempo de llenado a menos de 5 minutos.

## Solución propuesta

Aplicación Flutter Web con **modo pincel/multiselección**:

- Se selecciona un tipo de registro (# Total, C, D, E, J, P, N/A) y, si aplica, una cantidad
- Se toca o arrastra sobre las celdas del grid para aplicar el tipo de un solo movimiento
- Solo `# Total de atenciones` lleva valor numérico; el resto solo registra la letra correspondiente
- Diseño responsivo: funciona en computadora, tablet y celular

## Tipos de registro

| Clave | Descripción |
|-------|-------------|
| `#`   | Total de atenciones (lleva cantidad numérica) |
| `C`   | Capacitación |
| `D`   | Difusión |
| `E`   | Apoyo y/o participación en Eventos |
| `J`   | Justificante |
| `P`   | Planeación |
| `N/A` | No aplica |

## Estado del proyecto

| Fase | Estado |
|------|--------|
| Análisis del problema y capturas del sistema actual | ✅ Completado |
| Diseño UX/UI — mockup interactivo (HTML) | ✅ Completado |
| Spec y plan de implementación Flutter Web | 🔄 En progreso |
| Implementación Flutter Web (prototipo) | ⏳ Pendiente |
| Integración con API SIRI (pendiente autorización) | ⏳ Pendiente |

## Estructura del repositorio

```
EsquemaPILARES/
├── ImagenesDelProblema/   # Capturas del sistema actual que ilustran el problema
├── docs/                  # Especificaciones y planes de diseño (próximamente)
└── pilares_app/           # Proyecto Flutter Web (próximamente)
```

## Contexto

- **Usuarios:** Docentes y facilitadores del programa PILARES 2026, Ciberescuelas
- **Plataforma objetivo:** Flutter Web (desktop, tablet, móvil)
- **API futura:** SIRI (sistema interno PILARES — pendiente autorización)
- **Período de trabajo:** Abril 2026 —
