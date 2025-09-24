@echo off
echo 🚀 Starting subgraph deployment process...

REM Check if graph CLI is installed
where graph >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Graph CLI not found. Installing...
    npm install -g @graphprotocol/graph-cli
)

REM Generate code from schema and ABI
echo 📝 Generating TypeScript types...
call npm run codegen
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Code generation failed!
    exit /b 1
)

REM Build the subgraph
echo 🔨 Building subgraph...
call npm run build
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed!
    exit /b 1
)

echo ✅ Subgraph built successfully!

REM Check deployment target
if "%1"=="local" (
    echo 🏠 Deploying to local Graph Node...
    
    REM Create subgraph on local node
    call npm run create-local
    
    REM Deploy to local node
    call npm run deploy-local
    
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Successfully deployed to local Graph Node!
        echo 📊 Subgraph available at: http://localhost:8000/subgraphs/name/staking-subgraph
    ) else (
        echo ❌ Local deployment failed!
        exit /b 1
    )
    
) else if "%1"=="studio" (
    echo ☁️  Deploying to The Graph Studio...
    
    REM Check if auth token is set
    if "%GRAPH_AUTH_TOKEN%"=="" (
        echo ❌ GRAPH_AUTH_TOKEN environment variable not set!
        echo Please set your Graph Studio deploy key:
        echo set GRAPH_AUTH_TOKEN=your_deploy_key_here
        exit /b 1
    )
    
    REM Deploy to studio (deploy key is passed in the npm script)
    call npm run deploy
    
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Successfully deployed to The Graph Studio!
        echo 📊 Check your subgraph at: https://thegraph.com/studio/
    ) else (
        echo ❌ Studio deployment failed!
        exit /b 1
    )
    
) else (
    echo 📋 Usage: deploy.bat [local^|studio]
    echo.
    echo Options:
    echo   local   - Deploy to local Graph Node
    echo   studio  - Deploy to The Graph Studio
    echo.
    echo For studio deployment, set GRAPH_AUTH_TOKEN environment variable first:
    echo set GRAPH_AUTH_TOKEN=your_deploy_key_here
    exit /b 1
)

echo 🎉 Deployment completed!