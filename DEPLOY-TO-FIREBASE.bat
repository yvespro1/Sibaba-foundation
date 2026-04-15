@echo off
title Sibaba Foundation — Firebase Deploy
color 0A
echo.
echo  =====================================================
echo    SIBABA FOUNDATION — FIREBASE HOSTING DEPLOY
echo  =====================================================
echo.
echo  Step 1: Logging into Firebase...
echo  (Your browser will open — sign in with Google)
echo.
call firebase login
echo.
echo  Step 2: Deploying site to Firebase Hosting...
echo.
call firebase deploy --only hosting
echo.
echo  =====================================================
echo   DONE! Visit: https://sibaba-foundation.web.app
echo  =====================================================
echo.
pause
