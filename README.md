# Language Survival 🌍

Un juego educativo 3D donde aprendes idiomas sobreviviendo como inmigrante en un país extranjero.

## 📖 Concepto

Eres un inmigrante que llega a un país sin conocer el idioma. Debes trabajar en diferentes empleos, interactuar con vecinos y pagar tu renta mientras aprendes el idioma local a través de la inmersión total.

## 🎮 Mecánicas Principales

### Ciclo de Juego
1. **Trabajar** - Gana dinero en diferentes empleos
2. **Casa** - Descansa, ayuda vecinos, estudia el diccionario
3. **Pagar Renta** - Cada X días debes tener dinero para la renta

### Progresión de Trabajos

1. **Cajero de Supermercado** - Escanear productos, responder precios
2. **Mesero** - Tomar órdenes, servir mesas
3. **Recepcionista de Hotel** - Check-in, responder consultas
4. **Dependiente de Tienda de Ropa** - Ayudar con tallas y colores
5. **Asistente Administrativo** - Teléfono, emails, reuniones

### Sistema de Errores

- **3 errores menores** → Cliente se va enojado
- **1 error mayor** → ¡El jefe te persigue! Tienes 30-45 segundos para escapar
- Si te atrapa: quedas "desmayado" 10 segundos y pierdes clientes

### Mecánicas del Hogar

- **Diccionario 3D interactivo** - Consulta palabras por categoría o alfabéticamente
- **Vecinos** - Te piden ayuda y te pagan con dinero o items
- **Calendario/Reloj** - Controla los días y la renta
- **Cama** - Descansa para pasar al siguiente día

## 🗂️ Estructura del Proyecto

```
language-survival/
├── scenes/          # Escenas de Godot (.tscn)
│   ├── main/       # Menú principal y game manager
│   ├── jobs/       # Cada trabajo tiene su carpeta
│   ├── home/       # Apartamento y objetos interactivos
│   └── ui/         # Interfaces de usuario
├── scripts/         # Scripts GDScript (.gd)
│   ├── managers/   # Sistemas centrales (idioma, dinero, tiempo)
│   └── ai/         # IA de clientes, jefe, etc.
├── data/            # Datos del juego (JSON)
│   ├── languages/  # Vocabulario por idioma
│   └── items/      # Productos, menús, etc.
└── assets/          # Recursos visuales y audio
    ├── models/     # Modelos 3D
    ├── textures/   # Texturas e imágenes
    └── sounds/     # Audio y música
```

## 🚀 Cómo Empezar

### Requisitos
1. **Godot Engine 4.3+** - [Descargar aquí](https://godotengine.org/download)
2. Git (para clonar el repositorio)

### Instalación
```bash
# Clonar el repositorio
git clone <tu-repo-url>
cd game

# Abrir con Godot
# 1. Abre Godot Engine
# 2. Click en "Import"
# 3. Selecciona la carpeta del proyecto
# 4. Click en "Import & Edit"
```

### Primeros Pasos

El proyecto está configurado para:
- Resolución base: 1920x1080
- Modo: Forward+ rendering
- Controles: WASD para moverse, E para interactuar

## 📋 Plan de Desarrollo

### Fase 1: Prototipo (2-3 semanas)
- [ ] Apartamento básico navegable
- [ ] Sistema de diccionario funcional
- [ ] Un NPC vecino con diálogo

### Fase 2: Primera Versión Jugable (4-6 semanas)
- [ ] Nivel cajero completo con 20-30 productos
- [ ] Sistema de clientes con IA
- [ ] Jefe persiguiéndote
- [ ] Sistema de dinero y renta

### Fase 3: Expansión
- [ ] Trabajo de mesero
- [ ] Más vecinos e interacciones
- [ ] Más idiomas
- [ ] Sistema de progresión completo

## 🌐 Idiomas Disponibles

Inicialmente:
- Japonés
- Alemán
- (Más idiomas en desarrollo)

## 🛠️ Tecnologías

- **Motor**: Godot Engine 4.3
- **Lenguaje**: GDScript
- **Formato de Datos**: JSON
- **Gráficos**: 3D Forward+

## 📝 Notas de Desarrollo

- Los archivos `.tscn` son las escenas de Godot (en formato texto)
- Los archivos `.gd` contienen los scripts del juego
- La carpeta `.godot/` se genera automáticamente (ignorada por git)
- Los datos de idiomas se cargan dinámicamente desde JSON

## 🤝 Contribuciones

Este es un proyecto en desarrollo activo.

## 📜 Licencia

Por definir

---

**¡Buena suerte aprendiendo idiomas! 頑張って！Viel Erfolg!** 🎮
