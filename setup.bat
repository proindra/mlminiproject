@echo off

echo Creating virtual environment...

python -m venv .venv

echo.
echo Activating virtual environment...

call .venv\Scripts\activate

echo.
echo Upgrading pip...

python -m pip install --upgrade pip

echo.
echo Installing dependencies from requirements.txt...

pip install -r requirements.txt

echo.
echo ========================================
echo Environment setup completed successfully!
echo ========================================
echo.
echo To activate the environment later, run:
echo .venv\Scripts\activate

pause
