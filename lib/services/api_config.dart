/// Single source of truth for the backend's base URL.
///
/// - Android emulator -> host machine: http://10.0.2.2:PORT
/// - iOS simulator: http://localhost:PORT
/// - Physical device: http://<your-machine-LAN-IP>:PORT
///
/// Update this one constant if your backend's host/port changes — every
/// service (auth, providers, etc.) reads from here.
const String apiBaseUrl = 'http://10.0.2.2:8000';
