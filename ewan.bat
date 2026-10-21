cd "c:\Users\RAINIEL JOHN CALANGI\OneDrive\scancheck"
set GOOGLE_CLIENT_ID=556271478426-kbs3q9v1cb5p9n9ku1ms9rl2gf962jd7.apps.googleusercontent.com
set GOOGLE_CLIENT_SECRET=PASTE_CLIENT_SECRET

if "%GOOGLE_CLIENT_SECRET%"=="PASTE_CLIENT_SECRET" (
    echo Error: GOOGLE_CLIENT_SECRET is not configured. Please set your actual client secret in this batch file.
    exit /b 1
)

npm start
if errorlevel 1 (
    echo npm start failed with error code %errorlevel%
    exit /b %errorlevel%
)