# Diseño: Boleta de Atenciones PILARES — Nueva UX

**Fecha:** 2026-04-30
**Proyecto:** EsquemaPILARES
**Autor:** Aldo Zetina Muciño

---

## Problema

El sistema oficial `registro.pilares.cdmx.gob.mx` requiere llenar una tabla mensual celda por celda mediante modales. Cada celda implica 6 pasos: abrir modal → seleccionar tipo → ingresar cantidad → guardar → confirmar → cerrar. Con ~150 celdas por mes el proceso tarda más de 20 minutos.

**Objetivo medible:** reducir el tiempo de llenado a menos de 5 minutos.

---

## Usuarios

- Docentes y facilitadores del programa PILARES 2026, Ciberescuelas (múltiples usuarios)
- Uso en computadora de escritorio, tablet y celular

---

## Solución: Modo Pincel / Multiselección

El usuario selecciona un tipo de registro y una cantidad (solo si aplica), luego toca o arrastra sobre las celdas del grid para aplicarles ese tipo en un solo movimiento. Elimina la necesidad de abrir un modal por cada celda.

---

## Tipos de registro

| Clave | Descripción | Lleva cantidad numérica |
|-------|-------------|------------------------|
| `#`   | Total de atenciones | Sí |
| `C`   | Capacitación | No |
| `D`   | Difusión | No |
| `E`   | Apoyo y/o participación en Eventos | No |
| `J`   | Justificante | No |
| `P`   | Planeación | No |
| `N/A` | No aplica | No |

Solo `# Total de atenciones` muestra un valor numérico en la celda. Los demás solo muestran su letra clave.

---

## Estructura de pantallas

### 1. Encabezado (fijo, todas las plataformas)

- Logo PILARES + nombre del sistema
- Nombre del facilitador, asignación, figura, período del mes

### 2. Toolbar de tipo + cantidad

**Desktop:** barra horizontal en la parte superior del grid.

**Mobile / Tablet:** barra fija en la parte inferior de la pantalla (alcance del pulgar).

Contenido:
- Chips de tipo con código de color: `# Total`, `C`, `D`, `E`, `J`, `P`, `N/A`, `✕ Borrar`
- Stepper de cantidad (+/−) visible y activo solo cuando el tipo seleccionado es `# Total`
- Badge/texto que indica si el tipo seleccionado lleva o no cantidad

### 3. Grid mensual (área principal)

- Organizado por semanas (Semana 1 a Semana 5)
- Columnas: un día por columna (Lun–Dom según el mes)
- Filas dentro de cada día: H1, H2, H3, H4, H5+
- Las columnas de días usan `flex: 1` para repartirse equitativamente el ancho disponible sin espacios sobrantes
- **Desktop:** semana completa visible sin scroll horizontal
- **Mobile:** 7 días visibles, scroll vertical por semanas
- **Tablet:** igual que mobile pero con más espacio por celda

#### Código de color de celdas

| Tipo  | Fondo | Texto |
|-------|-------|-------|
| `#`   | verde claro `#e8f5ee` | verde `#2d6a4f` |
| `C`   | azul claro `#e3f0fd`  | azul `#1565c0`  |
| `D`   | naranja claro `#fff3e0` | naranja `#e65100` |
| `E`   | morado claro `#f3e5f5`  | morado `#6a1b9a` |
| `J`   | amarillo claro `#fff8e1` | ámbar `#f57f17` |
| `P`   | teal claro `#e0f2f1`    | teal `#00695c`  |
| `N/A` | gris claro `#f5f5f5`    | gris `#777`     |
| Vacía | `#fafafa` | `#ddd` |

#### Interacción de pintura

- **Toque simple:** aplica el tipo+cantidad seleccionado a esa celda
- **Arrastre (drag/swipe):** aplica a todas las celdas que el dedo o cursor toca durante el movimiento
- **Touch events:** `touchstart` + `touchmove` con `elementFromPoint` para detectar celda bajo el dedo

### 4. Barra de totales (fija al fondo — solo desktop)

- Total de horas mensual
- Total de atenciones mensual
- Total de horas de capacitación
- Botón **Guardar Boleta**

En mobile/tablet el botón Guardar vive dentro de la toolbar inferior.

---

## Comportamiento responsive

| Breakpoint | Toolbar | Grid | Totales |
|------------|---------|------|---------|
| Desktop (≥ 900px) | Arriba | Semana completa visible | Barra inferior fija |
| Tablet (600–899px) | Abajo | 7 días, scroll vertical | Dentro de toolbar |
| Mobile (< 600px) | Abajo | 7 días compactos, scroll vertical | Dentro de toolbar |

---

## Datos y estado

- El estado de cada celda se representa como `{ type: String, value: int? }` donde `value` solo es relevante cuando `type == '#'`
- Los datos se guardan localmente en memoria durante la sesión
- El botón Guardar envía todo el mes al backend en una sola llamada (cuando la API SIRI esté disponible)
- Por ahora (prototipo): guardar en memoria local / mock

---

## Fuera de alcance (prototipo)

- Autenticación de usuarios
- Integración real con API SIRI (pendiente autorización)
- Lógica de validación de reglas de negocio
- Navegación entre meses
- Roles y permisos multi-usuario

---

## Plataforma

- **Framework:** Flutter Web
- **Target:** Chrome, Edge (desktop + mobile)
- **Repositorio:** https://github.com/AldoZM/EsquemaPILARES
