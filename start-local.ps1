# Hydro HRMS Local Startup Script
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "      Starting Hydro HRMS Platform (Local Server)       " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "`n[1/2] Starting Backend Server (Port 8000)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$scriptDir\backend'; node src/server.js"

Write-Host "[2/2] Starting Frontend Vite Server (Port 5173)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$scriptDir\frontend'; npm run dev"

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host " Hydro HRMS is running locally!" -ForegroundColor Green
Write-Host "   Frontend Dashboard : http://localhost:5173" -ForegroundColor White
Write-Host "   Backend API        : http://localhost:8000/api" -ForegroundColor White
Write-Host "`n Default Login Credentials:" -ForegroundColor Yellow
Write-Host "   Email    : admin@hrms.com  (or admin@hydromaterial.com)" -ForegroundColor White
Write-Host "   Password : password123" -ForegroundColor White
Write-Host "========================================================`n" -ForegroundColor Cyan
