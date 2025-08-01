# habit_logger


Habit Logger es una aplicación móvil desarrollada con Flutter que te ayuda a establecer, rastrear y mantener hábitos saludables. La aplicación está diseñada para ser intuitiva y motivadora, permitiéndote registrar tu progreso diario y construir rutinas consistentes para tu bienestar personal.

✨ Características Principales
Autenticación de Usuario: Proceso de registro e inicio de sesión con validaciones.

Gestión de Hábitos: Funcionalidades CRUD (Crear, Leer, Actualizar, Eliminar) para tus hábitos diarios.

Seguimiento de Progreso: Marca tus hábitos como completados y visualiza tu consistencia.

Persistencia Local: Utiliza Hive para almacenar datos de usuario y hábitos directamente en el dispositivo, permitiendo el uso sin conexión a internet.

Arquitectura Modular: El proyecto está estructurado con una separación clara de responsabilidades, incluyendo un ApiService para simular la comunicación con un backend.

🛠️ Tecnologías Utilizadas
Flutter: Framework para el desarrollo de la interfaz de usuario.

Hive: Base de datos NoSQL local para el almacenamiento de datos.

path_provider: Para obtener la ruta del directorio de documentos de la aplicación.

http: Paquete para realizar peticiones HTTP y simular la interacción con una API.

🚀 Instalación y Uso
Prerrequisitos
Flutter SDK instalado.

Un editor de código (como VS Code o Android Studio).

Pasos
Clonar el repositorio:

Bash

git clone https://github.com/tu-usuario/habit-logger-app.git
cd habit-logger-app
Instalar dependencias:

Bash

flutter pub get
Generar adaptadores de Hive:

Este paso es crucial para que Hive pueda almacenar tus modelos de datos.

Bash

flutter packages pub run build_runner build
Ejecutar la aplicación:

Bash

flutter run
📂 Estructura del Proyecto
habit_logger_app/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── habit.dart
│   │   ├── habit.g.dart
│   │   ├── user.dart
│   │   └── user.g.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── ...
│   └── services/
│       └── api_service.dart
├── test/
├── pubspec.yaml
└── README.md
