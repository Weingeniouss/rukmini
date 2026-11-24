@echo off
echo ========================================================
echo   Starting Flutter Web Server on http://localhost:8080
echo   Opening Chrome with Disabled Web Security (No CORS)
echo ========================================================
echo.
start "" chrome.exe --disable-web-security --user-data-dir="%TEMP%\chrome_dev_session" http://localhost:8080
flutter run -d web-server --web-port 8080
pause
