@echo off
echo ========================================================
echo       Starting Hydro HRMS Platform (Local Server)
echo ========================================================
echo [1/2] Launching Backend Server on port 8000...
start "Hydro HRMS Backend (Port 8000)" cmd /k "cd /d %~dp0backend && node src/server.js"

echo [2/2] Launching Frontend Vite Server on port 5173...
start "Hydro HRMS Frontend (Port 5173)" cmd /k "cd /d %~dp0frontend && npm run dev"

echo.
echo ========================================================
echo  Hydro HRMS is now running!
echo  - Frontend UI (Vite Dev Server) : http://localhost:5173
echo  - Backend API & Web App         : http://localhost:8000
echo.
echo  Default Login Credentials:
echo    Email:    admin@hrms.com  (or admin@hydromaterial.com)
echo    Password: password123
echo ========================================================
pause
